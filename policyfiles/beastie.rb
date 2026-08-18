name 'beastie'

default_source :supermarket

include_policy 'ubuntu-base', path: '.'
include_policy 'multipass-vm', path: '.'

cookbook 'claude-code', path: '../cookbooks/claude-code'
cookbook 'github-cli', path: '../cookbooks/github-cli'

run_list(
  'claude-code',
  'github-cli'
)

username = 'tdg5'
group = username

default['user'] = {
  email: 'dannyguinther@gmail.com',
  group: group,
  home_directory: "/home/#{username}",
  username: username,
}

default['root_user'] = {
  group: 'root',
  username: 'root',
}
