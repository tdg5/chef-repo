username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/vim_endwise" do
  group node['user']['group']
  repository 'https://github.com/tpope/vim-endwise.git'
  revision '3719ffddb5e42bf67b55b2183d7a6fb8d3e5a2b8'
  user username
end
