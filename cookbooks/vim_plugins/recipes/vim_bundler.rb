user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/vim_bundler" do
  group user_group
  repository 'https://github.com/tpope/vim-bundler.git'
  revision 'c261509e78fc8dc55ad1fcf3cd7cdde49f35435c'
  user username
end
