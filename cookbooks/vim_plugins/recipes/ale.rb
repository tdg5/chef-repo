username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/ale" do
  group node['user']['group']
  repository 'https://github.com/dense-analysis/ale'
  revision '70eeae54fbd5c2e254604d543674f02d42c0ccdd'
  user username
end
