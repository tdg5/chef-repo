username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/vim_repeat" do
  group node['user']['group']
  repository 'https://github.com/tpope/vim-repeat.git'
  revision '24afe922e6a05891756ecf331f39a1f6743d3d5a'
  user username
end
