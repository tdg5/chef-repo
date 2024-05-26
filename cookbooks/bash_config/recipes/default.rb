user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

file "#{user_home_directory}/.bash_profile" do
  action :delete
  only_if "test -e #{user_home_directory}/.bash_profile"
end

template "#{user_home_directory}/.bashrc" do
  group user_group
  mode 0644
  owner username
end

cookbook_file "#{user_home_directory}/.bash_aliases" do
  group user_group
  mode 0644
  owner username
end

platform = node['platform']
if platform == 'mac_os_x'
  package 'bash-completion'
end

completion_dir = node['bash']['completion_dir']

if completion_dir
  root_user = node['root_user']['username']
  root_group = node['root_user']['group']

  node['bash']['completion'].each do |completion|
    cookbook_file "#{completion_dir}/#{completion}" do
      group root_group
      mode 0644
      owner root_user
      source "completion/#{completion}"
    end
  end
end
