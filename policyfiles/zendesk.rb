name 'zendesk'

default_source :supermarket

cookbook 'bash_config', path: '../cookbooks/bash_config'
cookbook 'cluster-storage', path: '../cookbooks/cluster-storage'
cookbook 'config', path: '../cookbooks/config'
cookbook 'exuberant-ctags', path: '../cookbooks/exuberant-ctags'
cookbook 'kube-prep', path: '../cookbooks/kube-prep'
cookbook 'liquidprompt', path: '../cookbooks/liquidprompt'
cookbook 'nfs-server', path: '../cookbooks/nfs-server'
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
  'ufw',
  'kube-prep',
  'cluster-storage',
  'nfs-server',
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

# Bulk-storage HDD relocated from proxima (4 TB Seagate ST4000DM000). These are
# node-specific identifiers consumed by the cluster-storage cookbook.
default['cluster_storage']['disk']['by_id'] = 'ata-ST4000DM000-1F2168_W3002BF7'
default['cluster_storage']['uuid'] = '0adb1308-714a-4af6-980a-e7b7f22df022'

# Split the HDD into an exported NFS subtree and node-local siblings. Only
# 'nfs' is served over NFS; 'bitcoind' is a node-local volume (its container
# entrypoint chowns the dir, so root-owned is fine).
default['cluster_storage']['subdirs'] = [
  { 'path' => 'nfs' },
  { 'path' => 'bitcoind' },
]

# Export ONLY the nfs subtree to the LAN/cluster for RWX persistent volumes.
# NFSv4 clients reach this on port 2049 (already opened in the ufw cookbook).
default['nfs_server']['exports'] = [
  {
    'path' => '/srv/cluster-storage/nfs',
    'network' => '192.168.1.0/24',
    'options' => 'rw,sync,no_subtree_check',
  },
]

# k3s networking: routed pod/service traffic needs FORWARD ACCEPT, and the pod
# (10.42.0.0/16) and service (10.43.0.0/16) CIDRs are trusted for all ports.
default['ufw']['forward_policy'] = 'ACCEPT'
default['ufw']['allow_from'] = ['10.42.0.0/16', '10.43.0.0/16']

# Files sourced from the generated ~/.bashrc. The template guards each with
# `[ -e <path> ]`, so entries whose file is absent are simply skipped.
default['bash']['bashrc']['extra_sources']['standard bash aliases'] = '~/.bash_aliases'
default['bash']['bashrc']['extra_sources']['extra, env dependent aliases'] = '~/.bash/extra_aliases'
default['bash']['bashrc']['extra_sources']['liquidprompt'] = '/opt/liquidprompt/liquidprompt'
default['bash']['bashrc']['extra_sources']['ssh agent'] = '~/.sshagentrc'
