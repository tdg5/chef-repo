username = node['user']['username']
user_group = node['user']['group']

template "/home/#{username}/.gitconfig" do
  group user_group
  mode 0644
  owner username
end

cookbook_file "/home/#{username}/.gitignore" do
  group user_group
  mode 0644
  owner username
end
