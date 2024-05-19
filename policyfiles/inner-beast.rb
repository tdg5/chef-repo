name 'inner-beast'

default_source :supermarket

include_policy 'ubuntu-base', path: '.'
include_policy 'kubernetes-client', path: '.'

cookbook 'noop', path: '../cookbooks/noop'

run_list ['noop']

username = 'tdg5'
group = username

default['user'] = {
  email: 'dannyguinther@gmail.com',
  group: group,
  home_directory: '/home/tdg5',
  username: username,
}

default['root_user'] = {
  group: 'root',
  username: 'root',
}
