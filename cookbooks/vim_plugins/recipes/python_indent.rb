user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/python-indent" do
  group user_group
  repository 'https://github.com/vim-scripts/indentpython.vim.git'
  revision '6aaddfde21fe9e7acbe448b92b3cbb67f2fe1fc1'
  user username
end
