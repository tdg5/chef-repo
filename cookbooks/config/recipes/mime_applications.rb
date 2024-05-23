user_group = node['user']['group']
user_home_directory = node['user']['home_directory']
username = node['user']['username']

cookbook_file "#{user_home_directory}/.local/share/applications/mimeapps.list" do
  group user_group
  mode '0664'
  owner username
end
