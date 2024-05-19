name 'gal'

default_source :supermarket

include_policy 'ubuntu-desktop', path: '.'
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
