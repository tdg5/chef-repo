# Answer connections that arrived on node['policy_routing']['interface'] back
# out through that interface and its gateway, instead of the main table's default
# route (on the cerberus VMs: Vagrant's eth0, which must keep the default route).
#
# Two halves:
#   1. nftables: tag every new connection that arrives on the interface in its
#      conntrack mark, and copy that tag onto each packet of the connection's
#      REPLY direction. A plain `from <our address>` rule can't catch the
#      interesting case: a reply from a pod behind a DNAT'd LoadBalancer IP is
#      routed while its source is still the pod IP; it is only un-DNAT'd in
#      POSTROUTING, after the routing decision. The tag is set in prerouting, so
#      it is there when that decision is made.
#   2. systemd-networkd: an `fwmark <mark>/<mark>` rule plus a `from <address>`
#      rule (replies from the host's own sockets) into a table whose default
#      route is the interface's gateway. The table throws private destinations
#      back to the main table, so LAN, pod, service and Vagrant traffic routes
#      exactly as before; only internet-bound replies change path.
#
# The rules and routes live in a networkd drop-in on netplan's generated unit for
# the interface, not in netplan itself: netplan's `routing-policy` has no
# fwmark mask (an exact `mark:` would miss packets that also carry kube-proxy's
# or kube-router's bits). Owning them in networkd also keeps networkd from
# flushing them as foreign when it restarts. Reverse-path filtering must be loose
# on the interface, since the inbound source's best route is via the main table's
# default (eth0); the drop-in pins that too.

iface = node['policy_routing']['interface']
gateway = node['policy_routing']['gateway']
raise 'policy-routing: set node[policy_routing][interface] and [gateway]' if iface.nil? || gateway.nil?

addresses = Array(node['policy_routing']['addresses'])
table = Integer(node['policy_routing']['table'])
priority = Integer(node['policy_routing']['priority'])
mark = format('0x%x', Integer(node['policy_routing']['mark']))
throw_destinations = Array(node['policy_routing']['throw_destinations'])

# A drop-in for a unit that doesn't exist silently does nothing, so refuse to
# converge unless netplan generated the unit we extend (it does so for any
# netplan `ethernets` id; Vagrant's 50-vagrant.yaml names the id after the NIC).
netplan_network = "10-netplan-#{iface}.network"
unless ::File.exist?("/run/systemd/network/#{netplan_network}")
  raise "policy-routing: /run/systemd/network/#{netplan_network} not found; " \
        "is #{iface} configured by netplan with the networkd renderer?"
end

package 'nftables'

# A name for the table, so `ip rule` / `ip route show table lan` read clearly.
file '/etc/iproute2/rt_tables.d/policy-routing.conf' do
  content "# Managed by Chef (policy-routing cookbook). Do not edit by hand.\n" \
          "#{table} lan\n"
  mode '0644'
  owner 'root'
  group 'root'
end

nft_table = 'policy_routing'
nft_file = '/etc/policy-routing.nft'

# `table` then `delete table` makes the load idempotent and atomic: the whole
# file is one transaction, so re-applying replaces the table without a window
# where the rules are missing. Its own table (not iptables-nft's `ip mangle`)
# keeps kube-proxy and kube-router, which rewrite their iptables-nft tables,
# from ever touching it; the prerouting hooks of both run on every packet.
file nft_file do
  content <<~NFT
    # Managed by Chef (policy-routing cookbook). Do not edit by hand.
    table ip #{nft_table}
    delete table ip #{nft_table}

    table ip #{nft_table} {
      chain prerouting {
        type filter hook prerouting priority mangle; policy accept;
        # Tag connections that arrive on #{iface}.
        iifname "#{iface}" ct state new ct mark set ct mark or #{mark}
        # Route their replies (from pods, or forwarded back from other nodes)
        # by the tag: `ip rule fwmark #{mark}/#{mark} lookup lan`.
        ct direction reply ct mark and #{mark} == #{mark} meta mark set meta mark or #{mark}
      }
    }
  NFT
  mode '0644'
  owner 'root'
  group 'root'
  notifies :reload_or_restart, 'systemd_unit[policy-routing.service]', :delayed
end

# Loaded before the network comes up, like the stock nftables.service (which
# stays disabled: its /etc/nftables.conf flushes the whole ruleset, k3s's
# included).
systemd_unit 'policy-routing.service' do
  content <<~UNIT
    # Managed by Chef (policy-routing cookbook). Do not edit by hand.
    [Unit]
    Description=Mark connections arriving on #{iface} for policy routing
    Wants=network-pre.target
    Before=network-pre.target shutdown.target
    Conflicts=shutdown.target
    DefaultDependencies=no

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/usr/sbin/nft -f #{nft_file}
    ExecReload=/usr/sbin/nft -f #{nft_file}
    ExecStop=/usr/sbin/nft delete table ip #{nft_table}

    [Install]
    WantedBy=sysinit.target
  UNIT
  action [:create, :enable, :start]
end

drop_in_dir = "/etc/systemd/network/#{netplan_network}.d"

directory drop_in_dir do
  mode '0755'
  owner 'root'
  group 'root'
end

routes = ["[Route]\nDestination=0.0.0.0/0\nGateway=#{gateway}\nTable=#{table}\n"]
routes += throw_destinations.map do |destination|
  "[Route]\nType=throw\nDestination=#{destination}\nTable=#{table}\n"
end
rules = ["[RoutingPolicyRule]\nFirewallMark=#{mark}/#{mark}\nTable=#{table}\nPriority=#{priority}\n"]
rules += addresses.map do |address|
  "[RoutingPolicyRule]\nFrom=#{address}\nTable=#{table}\nPriority=#{priority + 1}\n"
end

file "#{drop_in_dir}/60-policy-routing.conf" do
  content "# Managed by Chef (policy-routing cookbook). Do not edit by hand.\n" \
          "[Network]\n" \
          "IPv4ReversePathFilter=loose\n\n" +
          (routes + rules).join("\n")
  mode '0644'
  owner 'root'
  group 'root'
  notifies :run, 'execute[networkctl reload]', :immediately
end

# Re-reads the .network files and reconfigures the links whose config changed,
# without restarting networkd.
execute 'networkctl reload' do
  action :nothing
end
