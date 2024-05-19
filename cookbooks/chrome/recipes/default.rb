remote_file '/tmp/google-chrome-stable_current_amd64.deb' do
  backup false
  notifies :install, 'dpkg_package[google-chrome]'
  source 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
  not_if 'which google-chrome'
end

dpkg_package 'google-chrome' do
  action :nothing
  source '/tmp/google-chrome-stable_current_amd64.deb'
end

root_user = node['root_user']['username']
root_group = node['root_user']['group']
cookbook_file '/usr/local/bin/new_chrome_with_focus' do
  group root_group
  mode 0755
  owner root_user
end
