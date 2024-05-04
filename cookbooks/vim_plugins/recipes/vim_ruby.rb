username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/vim_ruby" do
  group node['user']['group']
  repository 'https://github.com/vim-ruby/vim-ruby.git'
  revision 'f06f069ce67bdda6f2cd408f8859cdf031e5b6b4'
  user username
end
