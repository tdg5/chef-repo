username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/vim-pathogen" do
  group node['user']['group']
  repository 'https://github.com/tpope/vim-pathogen.git'
  revision 'ac4dd9494fa9008754e49dff85bff1b5746c89b4'
  user username
end
