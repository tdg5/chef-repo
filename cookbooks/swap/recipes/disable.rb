# Disable swap and keep it off across reboots. The kubelet refuses to run with
# swap enabled, so every k3s node runs this. Idempotent: each step only acts
# when there is still swap to remove.

# Turn off all active swap devices/files now.
execute 'swapoff -a' do
  only_if 'swapon --show | grep -q .'
end

# Drop any swap entries from /etc/fstab so swap does not return on reboot.
execute 'remove swap entries from /etc/fstab' do
  command "sed -ri.bak '/[[:space:]]swap[[:space:]]/d' /etc/fstab"
  only_if "grep -Eq '[[:space:]]swap[[:space:]]' /etc/fstab"
end

# Reclaim the installer's swapfile once it is no longer in use.
swapfile = node['swap']['swapfile']
file swapfile do
  action :delete
  only_if { swapfile && ::File.exist?(swapfile) }
end
