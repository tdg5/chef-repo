user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

template "#{user_home_directory}/.gitconfig" do
  group user_group
  mode 0644
  owner username
end

cookbook_file "#{user_home_directory}/.gitignore" do
  group user_group
  mode 0644
  owner username
end
