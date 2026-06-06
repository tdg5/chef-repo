default['ufw']['enabled'] = true

# LAN/cluster CIDR that the allow rules below are scoped to. Because this is an
# IPv4 CIDR and there are no IPv6 allow rules, the host's routable IPv6 stays
# fully covered by the default-deny inbound policy.
default['ufw']['lan_cidr'] = '192.168.1.0/24'

# Default policy for the FORWARD chain. Kubernetes/k3s pod and service traffic
# is routed, so CNI nodes need 'ACCEPT'; plain hosts keep 'DROP'.
default['ufw']['forward_policy'] = 'DROP'

# CIDRs trusted for ALL ports (blanket `ufw allow from <cidr>`). Used for the
# k3s pod and service CIDRs so intra-cluster traffic is not filtered.
default['ufw']['allow_from'] = []

# Inbound allow rules, applied in order. SSH MUST be first so that enabling the
# firewall never severs the management connection.
default['ufw']['allow'] = [
  { 'port' => 22,    'proto' => 'tcp', 'comment' => 'SSH from LAN' },
  { 'port' => 8472,  'proto' => 'udp', 'comment' => 'k3s flannel VXLAN' },
  { 'port' => 10250, 'proto' => 'tcp', 'comment' => 'k3s kubelet' },
  { 'port' => 2049,  'proto' => 'tcp', 'comment' => 'NFSv4 from LAN' },
]
