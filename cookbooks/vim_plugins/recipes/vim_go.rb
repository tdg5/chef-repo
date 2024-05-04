username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/vim_go" do
  group node['user']['group']
  repository 'https://github.com/fatih/vim-go.git'
  revision 'feef9b31507f8e942bcd21f9e1f22d587c83c72d'
  user username
end
