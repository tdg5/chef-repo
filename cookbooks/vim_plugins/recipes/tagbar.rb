include_recipe 'exuberant-ctags'

username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/tagbar" do
  group node['user']['group']
  repository 'https://github.com/majutsushi/tagbar.git'
  revision '12edcb59449b335555652898f82dd6d5c59d519a'
  user username
end
