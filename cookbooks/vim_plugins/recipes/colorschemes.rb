user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/colorschemes" do
  group user_group
  repository 'https://github.com/flazz/vim-colorschemes.git'
  revision 'fd8f122cef604330c96a6a6e434682dbdfb878c9'
  user username
end
