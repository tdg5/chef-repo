# Provision and mount the bulk-storage HDD at a stable path for cluster
# persistent volumes (local-path today, NFS export later). Mirrors the manual
# setup from plan-zendesk-to-k8s.md Phase 2.4.
#
# SAFETY: the partition and format steps are guarded so they only ever run on a
# blank disk. Once the partition (matched by its GPT name) and the labelled
# filesystem exist, both steps are skipped -- so re-running chef, or
# reinstalling the OS while keeping this data disk, never reformats live data.

by_id = node['cluster_storage']['disk']['by_id']
uuid  = node['cluster_storage']['uuid']

raise "node['cluster_storage']['disk']['by_id'] must be set (see policyfile)" if by_id.nil?
raise "node['cluster_storage']['uuid'] must be set (see policyfile)" if uuid.nil?

label       = node['cluster_storage']['label']
fstype      = node['cluster_storage']['fstype']
mount_point = node['cluster_storage']['mount_point']
reserve     = node['cluster_storage']['reserved_blocks_percentage']

disk_device = "/dev/disk/by-id/#{by_id}"
part_device = "#{disk_device}-part1"

# sgdisk (gdisk) and partprobe (parted) drive partition creation.
package %w[ gdisk parted ]

# 1. Single GPT partition spanning the whole disk; GPT name == label.
execute 'partition cluster-storage disk' do
  command "sgdisk --zap-all #{disk_device} && " \
          "sgdisk -n 1:0:0 -t 1:8300 -c 1:#{label} #{disk_device} && " \
          "partprobe #{disk_device}"
  not_if { ::File.exist?(part_device) }
end

# 2. Format with a stable label and a pinned UUID. Guarded on the labelled
#    filesystem already existing, so it never reformats a provisioned disk.
mkfs_command =
  if fstype == 'ext4'
    "mkfs.ext4 -m #{reserve} -L #{label} -U #{uuid} #{part_device}"
  else
    "mkfs.#{fstype} -L #{label} #{part_device}"
  end

execute 'format cluster-storage disk' do
  command mkfs_command
  not_if "blkid -L #{label}"
end

# 3. Mount point and persistent mount by UUID.
directory mount_point do
  recursive true
  mode '0755'
end

mount mount_point do
  device uuid
  device_type :uuid
  fstype fstype
  options node['cluster_storage']['mount_options']
  action [:mount, :enable]
end

# 4. Node-local subtrees on the bulk disk. Created AFTER the mount so they live
#    on the HDD, not the underlying root filesystem. The 'nfs' subtree is the
#    only path the nfs-server cookbook exports; siblings (e.g. bitcoind) are
#    node-local volumes.
node['cluster_storage']['subdirs'].each do |sub|
  directory ::File.join(mount_point, sub['path']) do
    owner sub['owner'] || 'root'
    group sub['group'] || 'root'
    mode sub['mode'] || '0755'
    recursive true
  end
end
