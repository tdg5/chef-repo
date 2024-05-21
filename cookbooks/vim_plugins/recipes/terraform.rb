user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/terraform" do
  group user_group
  repository 'https://github.com/hashivim/vim-terraform.git'
  revision '24de93afb05078bac6a2e966402cc1f672277708'
  user username
end
