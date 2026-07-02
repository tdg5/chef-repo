# Provision and mount the cluster's storage disks at stable paths for persistent
# volumes (local-path today, the NFS export for the bulk subtree). Mirrors the
# manual setup from plan-zendesk-to-k8s.md Phase 2.4, extended to the SSD tier
# and extra bulk HDDs added later.
#
# SAFETY: the partition and format steps are guarded so they only ever run on a
# blank disk. Once a disk's -part1 partition and the labelled filesystem exist,
# both steps are skipped -- so re-running chef, listing an already-provisioned
# disk, or reinstalling the OS while keeping a data disk never reformats live
# data.

volumes = node['cluster_storage']['volumes']
defaults = node['cluster_storage']['defaults']

# sgdisk (gdisk) + partprobe (parted) drive partition creation; install once.
package %w( gdisk parted ) unless volumes.empty?

volumes.each do |vol|
  by_id       = vol['by_id']
  uuid        = vol['uuid']
  label       = vol['label']
  mount_point = vol['mount_point']

  raise "cluster_storage volume missing 'by_id' (label=#{label.inspect})" if by_id.nil? || by_id.empty?
  raise "cluster_storage volume missing 'uuid' (label=#{label.inspect})" if uuid.nil? || uuid.empty?
  raise "cluster_storage volume missing 'label'" if label.nil? || label.empty?
  raise "cluster_storage volume missing 'mount_point' (label=#{label.inspect})" if mount_point.nil? || mount_point.empty?

  fstype  = vol['fstype'] || defaults['fstype']
  options = vol['mount_options'] || defaults['mount_options']
  reserve = vol['reserved_blocks_percentage'] || defaults['reserved_blocks_percentage']
  subdirs = vol['subdirs'] || []

  disk_device = "/dev/disk/by-id/#{by_id}"
  part_device = "#{disk_device}-part1"

  # 1. Single GPT partition spanning the whole disk; GPT name == label.
  execute "partition #{label} disk" do
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

  execute "format #{label} disk" do
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
    options options
    action [:mount, :enable]
  end

  # 4. Subtrees on the disk, created AFTER the mount so they live on the disk,
  #    not the underlying root filesystem. The 'nfs' subtree is the only path the
  #    nfs-server cookbook exports; siblings (e.g. bitcoind) are node-local.
  subdirs.each do |sub|
    sub_path = ::File.join(mount_point, sub['path'])

    directory sub_path do
      owner sub['owner'] || 'root'
      group sub['group'] || 'root'
      mode sub['mode'] || '0755'
      recursive true
    end

    # Optional mount-proof sentinel, written INSIDE the subdir on the mounted
    # disk. A `local` Kubernetes PV does not check that its path is a real
    # mountpoint, and these disks mount with `nofail` -- so if a disk fails to
    # mount, kubelet serves the empty root-fs fallback dir instead, which once
    # let bitcoind come up with an empty chainstate. A consumer (e.g. the
    # bitcoind initContainer) asserts this file's presence before using the
    # path: it exists only when the disk is actually mounted, so its absence
    # makes the consumer fail loudly instead of silently running on empty data.
    next unless sub['sentinel']

    sentinel_name = sub['sentinel'].is_a?(String) ? sub['sentinel'] : '.cluster-disk-ok'
    file ::File.join(sub_path, sentinel_name) do
      content "cluster-storage mount marker -- managed by Chef (cluster-storage cookbook).\n" \
              "Presence proves #{mount_point} is mounted; its absence means the disk is not.\n"
      owner sub['owner'] || 'root'
      group sub['group'] || 'root'
      mode '0444'
    end
  end
end
