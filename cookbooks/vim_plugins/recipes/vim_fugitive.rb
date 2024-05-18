user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/vim_fugitive" do
  group user_group
  repository 'https://github.com/tpope/vim-fugitive.git'
  revision 'ce882460cf3db12e99f8bf579cbf99e331f6dd4f'
  user username
end
