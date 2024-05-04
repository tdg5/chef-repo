package 'ssh-askpass'

username = node['user']['username']
user_group = node['user']['group']

cookbook_file "/home/#{username}/.sshagentrc" do
  group user_group
  mode 0744
  owner username
end
