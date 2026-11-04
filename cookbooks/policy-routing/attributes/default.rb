# Symmetric return routing for a multi-homed host whose main default route is on
# a different NIC than the one inbound traffic arrives on -- the cerberus
# Vagrant/libvirt VMs, where Vagrant's management NIC (eth0) owns the default
# route but the LAN (and, via the router's port forward, the internet) reaches
# the node and its MetalLB IPs on the bridged eth1. Without this, replies to
# internet clients leave through eth0 and libvirt's NAT, and the handshake never
# completes. See recipes/default.rb for the mechanism.

# The NIC whose inbound connections must be answered through it, and its LAN
# gateway. Node-specific: set both in the policyfile.
default['policy_routing']['interface'] = nil
default['policy_routing']['gateway'] = nil

# The netplan `ethernets` id that configures the interface, when it is not the
# interface's own name. Vagrant names the id after the NIC (eth1), so nil there;
# multipass's network-config names a bridged NIC `extra0`.
default['policy_routing']['netplan_id'] = nil

# The host's own addresses on that NIC. Traffic the host itself sources from
# them (replies from host sockets) uses the table too.
default['policy_routing']['addresses'] = []

# Routing table holding the default route via the gateway, and the ip-rule
# priority of the fwmark rule (the source rule takes the next one). Both sit
# ahead of the main table's rule (32766). No other table or rule on the nodes
# uses these.
default['policy_routing']['table'] = 100
default['policy_routing']['priority'] = 100

# Connection/packet mark bit. Must not overlap the marks others set on the same
# packets: kube-proxy's 0x4000 (masquerade) and 0x8000 (drop), and the k3s
# network policy controller's (kube-router) 0x10000 and 0x20000. Flannel (vxlan)
# sets no marks. Everyone ORs/ANDs in their own bits, so one free bit coexists.
default['policy_routing']['mark'] = 0x100000

# Destinations the table never routes: the lookup "throws" back to the main
# table, which keeps its connected LAN route, pod (10.42/16, flannel) and
# service routes, and Vagrant's 192.168.121/24. So only internet-bound replies
# change path.
default['policy_routing']['throw_destinations'] = %w(10.0.0.0/8 172.16.0.0/12 192.168.0.0/16)
