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
zram_sysctls = {
  'vm.page-cluster' => 0,
  'vm.swappiness' => 180,
  'vm.watermark_boost_factor' => 0,
  'vm.watermark_scale_factor' => 125,
}

# Manage the sysctls via a dedicated drop-in and apply it explicitly. We do NOT
# use the core `sysctl` resource: its apply step runs bare `sysctl -p`, which
# reads /etc/sysctl.conf -- absent on Ubuntu 26.04 -- and fails. Applying our
# own file by path sidesteps that entirely. The drop-in also re-applies on boot
# via systemd-sysctl.
sysctl_conf = '/etc/sysctl.d/99-zram.conf'

file sysctl_conf do
  content(zram_sysctls.map { |key, value| "#{key} = #{value}" }.join("\n") + "\n")
  group root_group
  mode '0644'
  notifies :run, 'execute[apply zram sysctls]', :immediately
  owner root_username
end

# rubocop:disable Chef/Modernize/ExecuteSysctl -- the core `sysctl` resource is
# deliberately avoided here; see the comment above (its `sysctl -p` step fails
# on Ubuntu 26.04, which has no /etc/sysctl.conf).
execute 'apply zram sysctls' do
  command "sysctl -p #{sysctl_conf}"
  action :nothing
end
# rubocop:enable Chef/Modernize/ExecuteSysctl

# Remove legacy per-key drop-ins written by the core `sysctl` resource on
# earlier runs, so each key lives in exactly one file (idempotent no-op once
# they're gone).
zram_sysctls.each_key do |key|
  file "/etc/sysctl.d/99-chef-#{key}.conf" do
    action :delete
  end
end
