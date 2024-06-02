name 'beast'

default_source :supermarket

include_policy 'macos-base', path: '.'
include_policy 'kubernetes-client', path: '.'
include_policy 'dotnet-sdk', path: '.'

cookbook 'noop', path: '../cookbooks/noop'

run_list(
  'noop',
)

username = 'tdg5'
group = 'staff'

default['user'] = {
  email: 'dannyguinther@gmail.com',
  group: group,
  home_directory: '/Users/tdg5',
  username: username,
}

default['root_user'] = {
  group: 'admin',
  username: 'root',
}
