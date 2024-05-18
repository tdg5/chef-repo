user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

git "#{user_home_directory}/#{node['vim_plugins']['user_bundle_dir']}/ctrlp" do
  group user_group
  repository 'https://github.com/ctrlpvim/ctrlp.vim'
  revision '7c972cb19c8544c681ca345c64ec39e04f4651cc'
  user username
end
