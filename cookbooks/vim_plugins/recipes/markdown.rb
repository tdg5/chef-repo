user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/markdown" do
  group user_group
  repository 'https://github.com/plasticboy/vim-markdown.git'
  revision 'a657e697376909c41475a686eeef7fc7a4972d94'
  user username
end
