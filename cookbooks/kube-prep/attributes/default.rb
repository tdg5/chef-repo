# Kernel modules the CNI/kubelet need. Loaded now and on every boot.
default['kube_prep']['modules'] = %w[ overlay br_netfilter ]

# Sysctls required for bridged traffic to traverse iptables and for pod routing.
# br_netfilter must be loaded before the net.bridge.* keys exist, which is why
# the recipe loads modules first.
default['kube_prep']['sysctls'] = {
  'net.bridge.bridge-nf-call-iptables' => '1',
  'net.bridge.bridge-nf-call-ip6tables' => '1',
  'net.ipv4.ip_forward' => '1',
}
