root_username = node['root_user']['username']
root_group = node['root_user']['group']

cookbook_file '/etc/systemd/logind.conf' do
  group root_group
  mode '0644'
  owner root_username
end
