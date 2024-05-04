username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/matchit" do
  group node['user']['group']
  repository 'https://github.com/vim-scripts/matchit.zip.git'
  revision 'ced6c409c9beeb0b4142d21906606bd194411d1d'
  user username
end
