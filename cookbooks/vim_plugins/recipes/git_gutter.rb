user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/git_gutter" do
  group user_group
  repository 'https://github.com/airblade/vim-gitgutter'
  revision 'e801371917e52805a4ceb1e93f55ed1fba712f82'
  user username
end
