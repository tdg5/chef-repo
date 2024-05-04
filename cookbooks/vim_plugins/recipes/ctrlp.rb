username = node['user']['username']

git "/home/#{username}/#{node['vim_plugins']['user_bundle_dir']}/ctrlp" do
  group node['user']['group']
  repository 'https://github.com/ctrlpvim/ctrlp.vim'
  revision '7c972cb19c8544c681ca345c64ec39e04f4651cc'
  user username
end
