username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/easymotion" do
  group node['user']['group']
  repository 'https://github.com/Lokaltog/vim-easymotion.git'
  revision 'b3cfab2a6302b3b39f53d9fd2cd997e1127d7878'
  user username
end
