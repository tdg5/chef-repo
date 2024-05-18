user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/ale" do
  group user_group
  repository 'https://github.com/dense-analysis/ale'
  revision '70eeae54fbd5c2e254604d543674f02d42c0ccdd'
  user username
end
