username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/vim_surround" do
  group node['user']['group']
  repository 'https://github.com/tpope/vim-surround.git'
  revision '3d188ed2113431cf8dac77be61b842acb64433d9'
  user username
end
