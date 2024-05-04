name 'gal'

default_source :supermarket

include_policy 'universal', path: '.'

cookbook 'noop', path: '../cookbooks/noop'

run_list ['noop']

username = 'tdg5'
group = username

default["user"] = {
  email: 'dannyguinther@gmail.com',
  group: group,
  username: username,
}
