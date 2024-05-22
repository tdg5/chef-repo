name 'shade'

default_source :supermarket

include_policy 'ubuntu-base', path: '.'
include_policy 'multipass-vm', path: '.'
include_policy 'kubernetes-client', path: '.'
include_policy 'dotnet-core', path: '.'

cookbook 'noop', path: '../cookbooks/noop'

run_list(
  'noop',
)

username = 'danny'
group = username

default['user'] = {
  email: 'danny@phave.com',
  group: group,
  home_directory: "/home/#{username}",
  username: username,
}

default['root_user'] = {
  group: 'root',
  username: 'root',
}
