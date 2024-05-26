home_directory = node['user']['home_directory']
username = node['user']['username']
group_name = node['user']['group']

cookbook_file "#{home_directory}/.zprofile" do
  group group_name
  mode 0644
  owner username
end

template "#{home_directory}/.zshrc" do
  group group_name
  mode 0644
  owner username
end
