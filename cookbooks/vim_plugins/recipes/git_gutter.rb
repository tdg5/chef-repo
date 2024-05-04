username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/git_gutter" do
  group node['user']['group']
  repository 'https://github.com/airblade/vim-gitgutter'
  revision 'e801371917e52805a4ceb1e93f55ed1fba712f82'
  user username
end
