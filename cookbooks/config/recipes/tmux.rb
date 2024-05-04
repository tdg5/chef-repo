username = node['user']['username']
group_name = node['user']['group']

cookbook_file "/home/#{username}/.tmux.conf" do
  group group_name
  mode 0644
  owner username
end
