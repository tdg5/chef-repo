user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/vim_repeat" do
  group user_group
  repository 'https://github.com/tpope/vim-repeat.git'
  revision '24afe922e6a05891756ecf331f39a1f6743d3d5a'
  user username
end
