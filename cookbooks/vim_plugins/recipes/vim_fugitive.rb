username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/vim_fugitive" do
  group node['user']['group']
  repository 'https://github.com/tpope/vim-fugitive.git'
  revision 'ce882460cf3db12e99f8bf579cbf99e331f6dd4f'
  user username
end
