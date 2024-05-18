user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/json" do
  group user_group
  repository 'https://github.com/elzr/vim-json.git'
  revision '3727f089410e23ae113be6222e8a08dd2613ecf2'
  user username
end
