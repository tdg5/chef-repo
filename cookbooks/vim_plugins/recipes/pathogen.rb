user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/vim-pathogen" do
  group user_group
  repository 'https://github.com/tpope/vim-pathogen.git'
  revision 'ac4dd9494fa9008754e49dff85bff1b5746c89b4'
  user username
end
