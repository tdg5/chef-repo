name 'crackbook'

default_source :supermarket

cookbook 'bash_config', path: '../cookbooks/bash_config'
cookbook 'config', path: '../cookbooks/config'
cookbook 'exuberant-ctags', path: '../cookbooks/exuberant-ctags'
cookbook 'k3s-agent', path: '../cookbooks/k3s-agent'
cookbook 'kube-prep', path: '../cookbooks/kube-prep'
cookbook 'liquidprompt', path: '../cookbooks/liquidprompt'
cookbook 'node-specific', path: '../cookbooks/node-specific'
cookbook 'simple-packages', path: '../cookbooks/simple-packages'
cookbook 'swap', path: '../cookbooks/swap'
cookbook 'ufw', path: '../cookbooks/ufw'
cookbook 'vim_plugins', path: '../cookbooks/vim_plugins'
cookbook 'vim_wrapper', path: '../cookbooks/vim_wrapper'

run_list(
  # Standard interactive shell environment (subset of ubuntu-base; no
  # docker/desktop, server-safe on 26.04).
  'bash_config',
  'config::git',
  'config::sshagent',
  'vim_wrapper',
  'vim_plugins',
  'config::vim',
  'config::tmux',
  'liquidprompt',
  # Host infrastructure.
  'swap::disable',
  'config::sshd',
  'ufw',
  'kube-prep',
  # Laptop-specific host prep: clamshell lid-ignore, radios off, fan control,
  # powertop/governor/backlight tuning, USB-NIC autosuspend exemption. See
  # plan-2016-macbook-to-k8s.md Phase 2 (in the infrastructure repo).
  'node-specific::crackbook',
  'k3s-agent'
)

username = 'tdg5'
group = username

default['user'] = {
  email: 'dannyguinther@gmail.com',
  group: group,
  home_directory: '/home/tdg5',
  username: username,
}

default['root_user'] = {
  group: 'root',
  username: 'root',
}

# k3s networking: routed pod/service traffic needs FORWARD ACCEPT, and the pod
# (10.42.0.0/16) and service (10.43.0.0/16) CIDRs are trusted for all ports.
default['ufw']['forward_policy'] = 'ACCEPT'
default['ufw']['allow_from'] = ['10.42.0.0/16', '10.43.0.0/16']

# crackbook serves no NFS and carries no cluster storage, so drop the NFSv4 rule
# from the default allow list; keep SSH first plus the k3s flannel/kubelet ports.
# node-exporter (9100) is needed from the LAN, not just the pod CIDR: Prometheus
# scrapes the hostNetwork node-exporter at this node's host IP, which flannel
# masquerades, so the scrape arrives from a 192.168.1.x source rather than a
# 10.42.x.x pod IP and the allow_from pod-CIDR rule never matches it.
default['ufw']['allow'] = [
  { 'port' => 22,    'proto' => 'tcp', 'comment' => 'SSH from LAN' },
  { 'port' => 8472,  'proto' => 'udp', 'comment' => 'k3s flannel VXLAN' },
  { 'port' => 10250, 'proto' => 'tcp', 'comment' => 'k3s kubelet' },
  { 'port' => 9100,  'proto' => 'tcp', 'comment' => 'k3s node-exporter scrape' },
]

# Declarative k3s node config. Labels mirror what the agent is joined with
# (--node-label); managing them here makes a rebuilt node come up labelled. The
# server URL + secret token stay in the manually-created service env file.
# `node-tier=light` marks this 2C/4T best-effort worker so heavier workloads
# prefer beefier nodes (zendesk = node-tier=primary). No required_mounts:
# crackbook carries no cluster storage. To steer heavy pods away entirely, add
# 'node-taint' => ['node-tier=light:PreferNoSchedule'] here.
default['k3s_agent']['config'] = {
  'node-label' => ['node-tier=light'],
}

# The Realtek RTL8153 USB gigabit adapter is the node's ONLY NIC (confirmed via
# lsusb: 0bda:8153, in-kernel r8152 driver); node-specific::crackbook pins it out
# of USB autosuspend by id so powertop never drops the node to NotReady.
default['crackbook']['usb_nic']['id_vendor'] = '0bda'
default['crackbook']['usb_nic']['id_product'] = '8153'

# Files sourced from the generated ~/.bashrc. The template guards each with
# `[ -e <path> ]`, so entries whose file is absent are simply skipped.
default['bash']['bashrc']['extra_sources']['standard bash aliases'] = '~/.bash_aliases'
default['bash']['bashrc']['extra_sources']['extra, env dependent aliases'] = '~/.bash/extra_aliases'
default['bash']['bashrc']['extra_sources']['liquidprompt'] = '/opt/liquidprompt/liquidprompt'
default['bash']['bashrc']['extra_sources']['ssh agent'] = '~/.sshagentrc'
