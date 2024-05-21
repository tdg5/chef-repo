include_recipe 'simple-packages::cmake'

user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

you_complete_me_directory = "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/you-complete-me"
git 'you_complete_me_directory' do
  destination you_complete_me_directory
  group user_group
  enable_submodules true
  notifies :write, 'log[installation_warning]', :immediately
  repository 'https://github.com/ycm-core/YouCompleteMe.git'
  revision '4556062839aa2e86f2f4f1c0b4532697d607af23'
  user username
end

log 'installation_warning' do
  action :nothing
  message "You must run `/some/python3 #{you_complete_me_directory}/install.py` to complete YouCompleteMe installation"
  level :warn
end
