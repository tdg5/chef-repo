name 'gal'

default_source :supermarket

include_policy 'universal', path: '.'

cookbook 'noop', path: '../cookbooks/noop'

run_list ['noop']

username = 'tdg5'
group = username

default['bash']['bashrc']['extra_sources'] = {
  'Extra, env dependent aliases' => "~/.bash/extra_aliases",
}

default["user"] = {
  email: 'dannyguinther@gmail.com',
  group: group,
  username: username,
}
