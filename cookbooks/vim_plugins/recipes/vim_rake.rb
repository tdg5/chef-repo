username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/vim_rake" do
  group node['user']['group']
  repository 'https://github.com/tpope/vim-rake.git'
  revision 'af4ee966f5479fa89e60be067b6183f6addf9e4e'
  user username
end
