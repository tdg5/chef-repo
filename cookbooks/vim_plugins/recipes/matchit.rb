user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/matchit" do
  group user_group
  repository 'https://github.com/vim-scripts/matchit.zip.git'
  revision 'ced6c409c9beeb0b4142d21906606bd194411d1d'
  user username
end
