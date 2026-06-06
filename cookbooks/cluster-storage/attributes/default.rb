# Stable by-id path of the bulk-storage disk (survives sd* reordering). This is
# node-specific, so it MUST be set in the policyfile; there is no sane default.
default['cluster_storage']['disk']['by_id'] = nil

# Filesystem UUID. Pinned at format time (mkfs -U) so the mount-by-UUID entry is
# stable even if the disk is rebuilt. Node-specific; set it in the policyfile.
default['cluster_storage']['uuid'] = nil

default['cluster_storage']['label'] = 'cluster-bulk'
default['cluster_storage']['fstype'] = 'ext4'
default['cluster_storage']['mount_point'] = '/srv/cluster-storage'
default['cluster_storage']['mount_options'] = 'defaults,nofail'

# ext4 reserved-blocks percentage. 0 reclaims the default 5% on a bulk volume
# that holds no system files.
default['cluster_storage']['reserved_blocks_percentage'] = 0

# Subdirectories to create on the mounted disk. Each entry: 'path' (relative to
# mount_point), and optional 'owner'/'group'/'mode'. The 'nfs' subtree is the
# only path exported over NFS; siblings (e.g. bitcoind) are node-local. Set the
# concrete list in the policyfile.
default['cluster_storage']['subdirs'] = []
