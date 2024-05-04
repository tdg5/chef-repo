username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/vim_rails" do
  group node['user']['group']
  repository 'https://github.com/tpope/vim-rails.git'
  revision '8972461e64c7c4bf049f2f86ea1bc571e8077b55'
  user username
end
