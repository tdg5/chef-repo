username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/colorschemes" do
  group node['user']['group']
  repository 'https://github.com/flazz/vim-colorschemes.git'
  revision 'fd8f122cef604330c96a6a6e434682dbdfb878c9'
  user username
end
