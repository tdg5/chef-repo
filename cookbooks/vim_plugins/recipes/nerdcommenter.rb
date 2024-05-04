username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/nerdcommenter" do
  group node['user']['group']
  repository 'https://github.com/scrooloose/nerdcommenter.git'
  revision 'e361a44230860d616f799a337bc58f5218ab6e9c'
  user username
end
