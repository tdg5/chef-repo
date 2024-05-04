username = node['user']['username']

cookbook_file "/home/#{username}/.local/share/applications/mimeapps.list" do
  group node['user']['group']
  owner username
  mode 0664
end
