user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

installation_config = node['liquidprompt']['installation']
git installation_config['path'] do
  group installation_config['group']
  repository installation_config['repository']
  revision installation_config['revision']
  user installation_config['owner']
end

user_config_dir = "#{user_home_directory}/.config"

directory user_config_dir do
  group user_group
  owner username
  recursive true
end

template File.join(user_config_dir, 'liquidpromptrc') do
  group user_group
  owner username
  mode 0755
end

template File.join(user_config_dir, 'liquidprompt.ps1') do
  group user_group
  owner username
  mode 0755
end
