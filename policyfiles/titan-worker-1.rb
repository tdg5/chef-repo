name 'titan-worker-1'

default_source :supermarket

include_policy 'multipass-vm', path: '.'

cookbook 'k3s', path: '../cookbooks/k3s'
cookbook 'kube-prep', path: '../cookbooks/kube-prep'
cookbook 'policy-routing', path: '../cookbooks/policy-routing'
cookbook 'swap', path: '../cookbooks/swap'

# A cerberus worker for jig's Phave workers: the multipass VM on titan (Phave
# hardware; tdg5/infrastructure plans/phave-jig-worker/), launched with
# cloud-init/titan-worker-1.yaml and joined by k8s-at-home's
# scripts/install-k3s-agent.sh. Chef owns only the k3s host prep and the
# declarative node config -- no ubuntu-base shell environment and no ufw.
#
# Upgrades: the self-set `jig-worker=phave` label keeps the cluster's
# `k3s-agent` Plan off this node from registration; the operator then sets
# `node-restriction.kubernetes.io/jig-worker=phave` by `kubectl label` (a
# kubelet cannot set or remove that one itself), and the dedicated
# `k3s-jig-worker` Plan upgrades the node.
run_list(
  'swap::disable',
  'kube-prep',
  'policy-routing',
  'k3s::agent'
)

username = 'tdg5'
group = username

default['user'] = {
  email: 'dannyguinther@gmail.com',
  group: group,
  home_directory: "/home/#{username}",
  username: username,
}

default['root_user'] = {
  group: 'root',
  username: 'root',
}

# Declarative k3s agent config -- the ONLY source of its flags (see the k3s
# cookbook's attributes). The server URL + join token stay in the
# manually-created k3s-agent.service.env. node-ip / flannel-iface pin k3s and
# flannel to the bridged LAN NIC (enp0s2, 192.168.1.236 by DHCP reservation),
# not multipass's NAT NIC (enp0s1), the same names as shadow's (titan's trial
# VM, 2026-11-06). The taint keeps everything but jig's
# Phave workers (and DaemonSets that tolerate it) off the node.
default['k3s']['config'] = {
  'flannel-iface' => 'enp0s2',
  'node-ip' => '192.168.1.236',
  'node-label' => ['jig-worker=phave'],
  'node-taint' => ['jig-worker=phave:NoSchedule'],
}

# Answer connections that arrive on the bridged LAN NIC back through it and the
# router. multipass gives its NAT NIC (enp0s1) the main default route at metric
# 100 and the bridged NIC's at 200 (seen in shadow's and titan's trial VMs), so
# without this, replies to LAN clients leave through multipass's NAT. multipass's
# network-config names the bridged NIC's netplan id `extra0`, not `enp0s2`.
default['policy_routing'] = {
  'addresses' => ['192.168.1.236'],
  'gateway' => '192.168.1.1',
  'interface' => 'enp0s2',
  'netplan_id' => 'extra0',
}
