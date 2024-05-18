user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/vim_surround" do
  group user_group
  repository 'https://github.com/tpope/vim-surround.git'
  revision '3d188ed2113431cf8dac77be61b842acb64433d9'
  user username
end
