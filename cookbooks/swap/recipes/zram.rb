# Swap to zstd-compressed RAM via systemd-zram-generator, with kernel VM
# tuning suited to zram as the only swap device.
root_group = node['root_user']['group']
root_username = node['root_user']['username']

package 'systemd-zram-generator'

cookbook_file '/etc/systemd/zram-generator.conf' do
  group root_group
  mode '0644'
  notifies :run, 'execute[restart zram swap]', :immediately
  owner root_username
end

# The generator only runs on daemon-reload; restarting the setup unit then
# recreates /dev/zram0 at the configured size and re-enables it as swap.
execute 'restart zram swap' do
  command 'systemctl daemon-reload && systemctl restart systemd-zram-setup@zram0.service'
  action :nothing
end

# Swapping to compressed RAM is cheap, so prefer it over evicting page cache
# (swappiness > 100), and read single pages rather than clusters since there
# is no seek cost to amortize.
{
  'vm.page-cluster' => 0,
  'vm.swappiness' => 180,
  'vm.watermark_boost_factor' => 0,
  'vm.watermark_scale_factor' => 125,
}.each do |key, value|
  sysctl key do
    value value
  end
end
