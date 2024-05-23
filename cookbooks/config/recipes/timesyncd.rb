root_group = node['root_user']['group']
root_username = node['root_user']['username']

cookbook_file "/etc/systemd/timesyncd.conf" do
  group root_group
  mode '0644'
  notifies :restart, 'systemd_unit[systemd-timesyncd.service]', :immediately
  owner root_username
end

systemd_unit 'systemd-timesyncd.service' do
  action :nothing
end
