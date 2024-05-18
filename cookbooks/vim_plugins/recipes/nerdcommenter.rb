user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/nerdcommenter" do
  group user_group
  repository 'https://github.com/scrooloose/nerdcommenter.git'
  revision 'e361a44230860d616f799a337bc58f5218ab6e9c'
  user username
end
