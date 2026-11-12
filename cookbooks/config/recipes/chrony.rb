# Harden chrony against the guest clock freezing while an Apple Silicon host
# sleeps. Newer Ubuntu images (e.g. 26.04) ship chrony as the default time
# daemon; this is the chrony counterpart to config::timesyncd, and like it only
# acts when the daemon's unit is actually installed.
chrony_unit = 'chrony.service'

if ::File.exist?("/usr/lib/systemd/system/#{chrony_unit}")
  root_group = node['root_user']['group']
  root_username = node['root_user']['username']

  cookbook_file '/etc/chrony/conf.d/10-vm-clock.conf' do
    source 'chrony-vm-clock.conf'
    group root_group
    mode '0644'
    notifies :restart, "systemd_unit[#{chrony_unit}]", :immediately
    owner root_username
  end

  systemd_unit chrony_unit do
    action :nothing
  end

  # A timer that forces fresh NTP measurements every few minutes so a
  # sleep-induced jump is caught soon after resume rather than at the next
  # (up to ~17 minute) poll.
  %w(chrony-resync.service chrony-resync.timer).each do |unit|
    cookbook_file "/etc/systemd/system/#{unit}" do
      group root_group
      mode '0644'
      notifies :run, 'execute[chrony-resync daemon-reload]', :immediately
      owner root_username
    end
  end

  execute 'chrony-resync daemon-reload' do
    command 'systemctl daemon-reload'
    action :nothing
  end

  systemd_unit 'chrony-resync.timer' do
    action [:enable, :start]
  end
else
  log "skipping chrony config: #{chrony_unit} not installed" do
    level :info
  end
end
