username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/vim_bundler" do
  group node['user']['group']
  repository 'https://github.com/tpope/vim-bundler.git'
  revision 'c261509e78fc8dc55ad1fcf3cd7cdde49f35435c'
  user username
end
