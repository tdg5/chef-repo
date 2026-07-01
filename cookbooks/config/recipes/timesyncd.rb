# systemd-timesyncd isn't present on every platform. Newer Ubuntu images
# (e.g. 26.04) ship chrony as the default time daemon, and chrony displaces
# systemd-timesyncd -- so its unit doesn't exist and restarting it fails with
# "Unit not found". Only manage timesyncd when its unit is actually installed;
# where it isn't, another daemon (chrony) already handles time sync. This
# self-heals if a future image ships timesyncd again.
timesyncd_unit = 'systemd-timesyncd.service'

if ::File.exist?("/usr/lib/systemd/system/#{timesyncd_unit}")
  root_group = node['root_user']['group']
  root_username = node['root_user']['username']

  cookbook_file '/etc/systemd/timesyncd.conf' do
    group root_group
    mode '0644'
    notifies :restart, "systemd_unit[#{timesyncd_unit}]", :immediately
    owner root_username
  end

  systemd_unit timesyncd_unit do
    action :nothing
  end
else
  log "skipping #{timesyncd_unit} config: unit not installed (another time daemon, e.g. chrony, handles sync here)" do
    level :info
  end
end
