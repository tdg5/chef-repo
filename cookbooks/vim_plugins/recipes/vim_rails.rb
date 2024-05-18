user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/vim_rails" do
  group user_group
  repository 'https://github.com/tpope/vim-rails.git'
  revision '8972461e64c7c4bf049f2f86ea1bc571e8077b55'
  user username
end
