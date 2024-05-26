package 'nvm'

username = node['user']['username']
user_group = node['user']['group']
user_home_directory = node['user']['home_directory']

directory ::File.join(user_home_directory, ".nvm") do
  group user_group
  owner username
end
