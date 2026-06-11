# cluster-storage provisions one or more dedicated storage disks (bulk HDDs, an
# SSD tier, ...) at stable mount points for Kubernetes persistent volumes
# (local-path today, the NFS export for the bulk subtree). Each disk gets a
# single GPT partition, is formatted with a stable label and pinned UUID, and is
# mounted by UUID. The destructive partition/format steps are guarded so they
# only run on a blank disk.
#
# The concrete disk list is node-specific and MUST be set in the policyfile;
# there is no sane default. Each entry in node['cluster_storage']['volumes'] is:
#
#   'by_id'        (required) stable /dev/disk/by-id name (survives sd* reorder)
#   'uuid'         (required) filesystem UUID, pinned at format time (mkfs -U)
#   'label'        (required) filesystem + GPT partition label
#   'mount_point'  (required) absolute mount path
#   'fstype'       (optional) defaults to ['defaults']['fstype'] below
#   'mount_options'(optional) defaults to ['defaults']['mount_options'] below
#   'reserved_blocks_percentage' (optional, ext4) defaults below
#   'subdirs'      (optional) [{ 'path' => ..., 'owner'/'group'/'mode' => ...,
#                  'sentinel' => true|'<name>' }], created on the mounted disk
#                  after mount. The 'nfs' subtree is the only path the nfs-server
#                  cookbook exports; siblings (e.g. bitcoind) are node-local
#                  volumes. 'sentinel' writes a mount-proof marker file inside the
#                  subdir (default name '.cluster-disk-ok', or the given string):
#                  it lives only on the mounted disk, so a consumer can assert the
#                  disk is really mounted before using a `local` PV path (which
#                  does not itself verify the mount; see the recipe).
default['cluster_storage']['volumes'] = []

# Per-volume fallbacks the recipe applies when an entry omits the key.
default['cluster_storage']['defaults']['fstype'] = 'ext4'
# nofail so a missing/failed data disk never blocks boot.
default['cluster_storage']['defaults']['mount_options'] = 'defaults,nofail'
# ext4 reserved-blocks percentage. 0 reclaims the default 5% on a bulk volume
# that holds no system files.
default['cluster_storage']['defaults']['reserved_blocks_percentage'] = 0
