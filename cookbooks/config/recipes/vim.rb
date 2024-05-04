username = node['user']['username']
group_name = node['user']['group']

cookbook_file "/home/#{username}/.vimrc" do
  group group_name
  mode 0644
  owner username
end
