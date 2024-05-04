username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/json" do
  group node['user']['group']
  repository 'https://github.com/elzr/vim-json.git'
  revision '3727f089410e23ae113be6222e8a08dd2613ecf2'
  user username
end
