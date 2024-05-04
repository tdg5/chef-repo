username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/markdown" do
  group node['user']['group']
  repository 'https://github.com/plasticboy/vim-markdown.git'
  revision 'a657e697376909c41475a686eeef7fc7a4972d94'
  user username
end
