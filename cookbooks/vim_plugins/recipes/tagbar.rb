include_recipe 'exuberant-ctags'

user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/tagbar" do
  group user_group
  repository 'https://github.com/majutsushi/tagbar.git'
  revision '12edcb59449b335555652898f82dd6d5c59d519a'
  user username
end
