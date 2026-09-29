name 'k3s-server'

default_source :supermarket

cookbook 'k3s', path: '../cookbooks/k3s'
cookbook 'kube-prep', path: '../cookbooks/kube-prep'
cookbook 'policy-routing', path: '../cookbooks/policy-routing'
cookbook 'swap', path: '../cookbooks/swap'

# The cerberus control-plane node: a Vagrant/libvirt VM (hostname `server`)
# created by the k8s-at-home repo, whose install script ran the initial k3s
# install + join. Chef owns only the k3s host prep and the declarative node
# config -- no shell environment (the VM's login user is `vagrant`) and no ufw
# (the firewall is off on the VMs; enabling it is its own change).
run_list(
  'swap::disable',
  'kube-prep',
  'policy-routing',
  'k3s::server'
)

# Declarative k3s server config -- the ONLY source of its flags. The installer
# originally baked these onto the unit's ExecStart; the k3s cookbook now resets
# ExecStart to a bare `k3s server`, so a flag missing here is a flag k3s no
# longer gets. The join token stays in the manually-created k3s.service.env.
#   disable: components this cluster replaces or must not run --
#     gateway-api-crd  k3s >= 1.37 (and the 1.36.5 backport) otherwise force-takes
#                      over the Gateway API CRDs as standard channel, clobbering
#                      the experimental set envoy-gateway-crds installs. It must be
#                      disabled BEFORE the first start on such a version: disabling
#                      it later uninstalls the chart, deleting the CRDs and every
#                      Gateway/Route with them.
#     servicelb        MetalLB owns LoadBalancer Services.
#     traefik          Envoy Gateway is the ingress.
#   kube-apiserver-arg runtime-config: also serve the beta
#     certificates.k8s.io/v1beta1 API (ClusterTrustBundle, PodCertificateRequest)
#     for clients that still speak it. Those resources are GA and served at
#     certificates.k8s.io/v1 by default since k8s 1.37; beta group versions are
#     off unless enabled here. Drop this BEFORE upgrading to a k8s release that
#     removes v1beta1 -- kube-apiserver refuses to start on a runtime-config entry
#     for an unknown group version.
#   node-ip / flannel-iface / tls-san: pin k3s and flannel to the bridged LAN NIC
#     (eth1, 192.168.1.200), not Vagrant's eth0 management network.
#   node-taint: keeps workloads off the control plane. Applied only when the node
#     registers, so this makes a rebuilt server come up tainted; the running node
#     already carries it.
#   write-kubeconfig-mode: k3s.yaml readable by the login user.
default['k3s']['config'] = {
  'disable' => %w(gateway-api-crd servicelb traefik),
  'flannel-iface' => 'eth1',
  'kube-apiserver-arg' => ['runtime-config=certificates.k8s.io/v1beta1=true'],
  'node-ip' => '192.168.1.200',
  'node-taint' => ['node-role.kubernetes.io/control-plane:NoSchedule'],
  'tls-san' => ['192.168.1.200'],
  'write-kubeconfig-mode' => '644',
}

# Answer connections that arrive on the bridged LAN NIC back through it and the
# router, not via the main table's default route (Vagrant's eth0 / libvirt NAT,
# which Vagrant needs and so keeps). Without this, an internet client reaching a
# MetalLB IP announced from this node (the router forwards WAN :443 to one) gets
# its SYN-ACK sent out eth0 and never completes the handshake.
default['policy_routing'] = {
  'addresses' => ['192.168.1.200'],
  'gateway' => '192.168.1.1',
  'interface' => 'eth1',
}
