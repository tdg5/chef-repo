username = node['user']['username']
user_group = node['user']['group']

file "/home/#{username}/.bash_profile" do
  action :delete
  only_if "file -e /home/#{username}/.bash_profile"
end

template "/home/#{username}/.bashrc" do
  group user_group
  mode 0644
  owner username
end

cookbook_file "/home/#{username}/.bash_aliases" do
  group user_group
  mode 0644
  owner username
end

node['bash']['completion'].each do |completion|
  cookbook_file "/etc/bash_completion.d/#{completion}" do
    group 'root'
    mode 0644
    owner 'root'
    source "completion/#{completion}"
  end
end
