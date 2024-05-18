user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/vim_rake" do
  group user_group
  repository 'https://github.com/tpope/vim-rake.git'
  revision 'af4ee966f5479fa89e60be067b6183f6addf9e4e'
  user username
end
