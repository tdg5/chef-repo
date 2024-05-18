user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/vim-trailing-whitespace" do
  group user_group
  repository 'https://github.com/bronson/vim-trailing-whitespace.git'
  revision '5540b3faa2288b226a8d9a4e8244558b12c598aa'
  user username
end
