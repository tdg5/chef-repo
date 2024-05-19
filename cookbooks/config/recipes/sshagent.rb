package 'ssh-askpass'

user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

cookbook_file "#{user_home_directory}/.sshagentrc" do
  group user_group
  mode 0744
  owner username
end
