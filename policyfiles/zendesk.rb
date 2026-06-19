name 'zendesk'

default_source :supermarket

cookbook 'bash_config', path: '../cookbooks/bash_config'
cookbook 'cluster-storage', path: '../cookbooks/cluster-storage'
cookbook 'config', path: '../cookbooks/config'
cookbook 'exuberant-ctags', path: '../cookbooks/exuberant-ctags'
cookbook 'k3s-agent', path: '../cookbooks/k3s-agent'
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
  'config::sshd',
  'ufw',
  'kube-prep',
  'cluster-storage',
  'nfs-server',
  'k3s-agent',
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

# Storage disks on zendesk, consumed by the cluster-storage cookbook. Each is a
# single-GPT-partition ext4 volume mounted by UUID (defaults,nofail). The
# partition/format steps are guarded, so listing an already-provisioned disk is a
# safe no-op. Held in a local so the k3s-agent required_mounts list below can be
# derived from the same source of truth.
cluster_storage_volumes = [
  # 4 TB bulk HDD (Seagate ST4000DM000), relocated from proxima. Split into an
  # exported NFS subtree and node-local siblings; only 'nfs' is served over NFS.
  # 'bitcoind' holds the node's block data (the container entrypoint chowns it,
  # so root-owned is fine). 'sentinel' writes a mount-proof marker the bitcoind
  # initContainer checks before starting (guards against a nofail unmount).
  {
    'by_id' => 'ata-ST4000DM000-1F2168_W3002BF7',
    'uuid' => '0adb1308-714a-4af6-980a-e7b7f22df022',
    'label' => 'cluster-bulk',
    'mount_point' => '/srv/cluster-storage',
    'subdirs' => [
      { 'path' => 'nfs' },
      { 'path' => 'bitcoind', 'sentinel' => true },
    ],
  },
  # SSD tier (OCZ Vertex 3, 80 GB). Fast random-IO storage; holds bitcoind's
  # chainstate (UTXO LevelDB) at /srv/cluster-ssd/bitcoind, overlaid into the pod
  # at /data/chainstate. Owned 101:101 to match the bitcoind container user — the
  # chainstate dir is the volume's mount target, not chowned by the entrypoint.
  # 'sentinel' writes a mount-proof marker the bitcoind initContainer checks; this
  # is the disk that came up unmounted once and left the chainstate empty.
  {
    'by_id' => 'ata-OCZ-VERTEX3_OCZ-Z1NV0AX5ZHN6VSSL',
    'uuid' => '120e6ace-5016-404d-9f61-79b1fd0efc66',
    'label' => 'cluster-ssd',
    'mount_point' => '/srv/cluster-ssd',
    'subdirs' => [
      { 'path' => 'bitcoind', 'owner' => 101, 'group' => 101, 'sentinel' => true },
      { 'path' => 'postgres' },
    ],
  },
  # Bulk HDD #2 (WD WD10EAVS, 1 TB). Node-local dynamic bulk capacity backing the
  # `local-path-bulk` StorageClass; the provisioner creates per-PVC dirs at the
  # mount root, so no pre-created subdirs.
  {
    'by_id' => 'ata-WDC_WD10EAVS-00D7B1_WD-WCAU45839341',
    'uuid' => '3fc28a74-bac3-4cd7-9cac-a02220b048a2',
    'label' => 'cluster-bulk2',
    'mount_point' => '/srv/cluster-storage-2',
  },
  # Bulk HDD #3 (WD WD10JPVT, 1 TB). Second disk behind `local-path-bulk`; the
  # provisioner spreads volumes across this and cluster-bulk2.
  {
    'by_id' => 'ata-WDC_WD10JPVT-22A1YT0_WD-WX21C6280059',
    'uuid' => '6e74648b-26d1-43a1-beb2-9d6cdda18e1f',
    'label' => 'cluster-bulk3',
    'mount_point' => '/srv/cluster-storage-3',
  },
]
default['cluster_storage']['volumes'] = cluster_storage_volumes

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

# Override the cookbook default allow list so SSH is reachable from the internet:
# the router forwards external 61922 -> this host:22, and the forwarded packet
# keeps the remote client's public source IP, so a LAN-scoped rule would drop it.
# SSH therefore uses `from => 'any'`; everything else stays LAN-scoped. Password
# auth is disabled (config::sshd), so this is key-only exposure. NOTE: `from any`
# also opens port 22 on IPv6 if the host has routable v6.
default['ufw']['allow'] = [
  { 'port' => 22,    'proto' => 'tcp', 'from' => 'any', 'comment' => 'SSH (router-forwarded 61922)' },
  { 'port' => 8472,  'proto' => 'udp', 'comment' => 'k3s flannel VXLAN' },
  { 'port' => 10250, 'proto' => 'tcp', 'comment' => 'k3s kubelet' },
  { 'port' => 9100,  'proto' => 'tcp', 'comment' => 'k3s node-exporter scrape' },
  { 'port' => 2049,  'proto' => 'tcp', 'comment' => 'NFSv4 from LAN' },
]

# Declarative k3s node config. Labels mirror what the agent was joined with
# (--node-label); managing them here makes a rebuilt node come up labelled. The
# server URL + secret token stay in the manually-created service env file.
default['k3s_agent']['config'] = {
  'node-label' => ['node-tier=primary', 'storage-node=true'],
}

# Gate k3s-agent startup on every cluster-storage disk being mounted. These disks
# back `local`/local-path PVs, and the agent must not serve an empty root-fs
# fallback dir when a `nofail` disk failed to mount (the failure mode that once
# wiped bitcoind's chainstate). Rendered as RequiresMountsFor in a systemd
# drop-in; `nofail` still keeps the box booting/reachable if a disk is missing.
default['k3s_agent']['required_mounts'] =
  cluster_storage_volumes.map { |vol| vol['mount_point'] }

# Files sourced from the generated ~/.bashrc. The template guards each with
# `[ -e <path> ]`, so entries whose file is absent are simply skipped.
default['bash']['bashrc']['extra_sources']['standard bash aliases'] = '~/.bash_aliases'
default['bash']['bashrc']['extra_sources']['extra, env dependent aliases'] = '~/.bash/extra_aliases'
default['bash']['bashrc']['extra_sources']['liquidprompt'] = '/opt/liquidprompt/liquidprompt'
default['bash']['bashrc']['extra_sources']['ssh agent'] = '~/.sshagentrc'
