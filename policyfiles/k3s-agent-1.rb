name 'k3s-agent-1'

default_source :supermarket

cookbook 'k3s', path: '../cookbooks/k3s'
cookbook 'kube-prep', path: '../cookbooks/kube-prep'
cookbook 'policy-routing', path: '../cookbooks/policy-routing'
cookbook 'swap', path: '../cookbooks/swap'

# A cerberus worker: a Vagrant/libvirt VM (hostname `agent-1`) created by the
# k8s-at-home repo, whose install script ran the initial k3s install + join.
# Chef owns only the k3s host prep and the declarative node config -- no shell
# environment (the VM's login user is `vagrant`) and no ufw (the firewall is off
# on the VMs; enabling it is its own change).
run_list(
  'swap::disable',
  'kube-prep',
  'policy-routing',
  'k3s::agent'
)

# Declarative k3s agent config -- the ONLY source of its flags. The installer
# originally baked these onto the unit's ExecStart; the k3s cookbook now resets
# ExecStart to a bare `k3s agent`, so a flag missing here is a flag k3s no longer
# gets. The server URL + join token stay in the manually-created
# k3s-agent.service.env. node-ip / flannel-iface pin k3s and flannel to the
# bridged LAN NIC (eth1, 192.168.1.201), not Vagrant's eth0 management network.
# No node labels (the node was joined without any) and no required_mounts: the
# VM's /mnt/data disk backs no cluster storage today.
default['k3s']['config'] = {
  'flannel-iface' => 'eth1',
  'node-ip' => '192.168.1.201',
}

# Answer connections that arrive on the bridged LAN NIC back through it and the
# router, not via the main table's default route (Vagrant's eth0 / libvirt NAT,
# which Vagrant needs and so keeps). Without this, an internet client reaching a
# MetalLB IP announced from this node (the router forwards WAN :443 to one) gets
# its SYN-ACK sent out eth0 and never completes the handshake.
default['policy_routing'] = {
  'addresses' => ['192.168.1.201'],
  'gateway' => '192.168.1.1',
  'interface' => 'eth1',
}
