user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/easymotion" do
  group user_group
  repository 'https://github.com/Lokaltog/vim-easymotion.git'
  revision 'b3cfab2a6302b3b39f53d9fd2cd997e1127d7878'
  user username
end
