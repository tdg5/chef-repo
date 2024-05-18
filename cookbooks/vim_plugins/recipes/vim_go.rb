user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/vim_go" do
  group user_group
  repository 'https://github.com/fatih/vim-go.git'
  revision 'feef9b31507f8e942bcd21f9e1f22d587c83c72d'
  user username
end
