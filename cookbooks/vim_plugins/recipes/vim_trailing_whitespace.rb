username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/vim-trailing-whitespace" do
  group node['user']['group']
  repository 'https://github.com/bronson/vim-trailing-whitespace.git'
  revision '5540b3faa2288b226a8d9a4e8244558b12c598aa'
  user username
end
