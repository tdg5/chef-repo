user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

plugin_directory = "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/mlessnau_block_shift/plugin"

directory plugin_directory do
  group user_group
  recursive true
  user username
end

cookbook_file "#{plugin_directory}/mlessnau_block_shift.vim" do
  group user_group
  user username
end
