user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/vim_obsession" do
  group user_group
  repository 'https://github.com/tpope/vim-obsession.git'
  revision 'fe9d3e1a9a50171e7d316a52e1e56d868e4c1fe5'
  user username
end
