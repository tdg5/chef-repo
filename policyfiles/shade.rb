name 'shade'

default_source :supermarket

include_policy 'ubuntu-base', path: '.'
include_policy 'multipass-vm', path: '.'
include_policy 'kubernetes-client', path: '.'
include_policy 'dotnet-core', path: '.'

cookbook 'azure-cli', path: '../cookbooks/azure-cli'
cookbook 'claude-code', path: '../cookbooks/claude-code'
cookbook 'earlyoom', path: '../cookbooks/earlyoom'
cookbook 'github-cli', path: '../cookbooks/github-cli'
cookbook 'swap', path: '../cookbooks/swap'

run_list(
  'azure-cli',
  'claude-code',
  'github-cli',
  'swap::zram',
  'earlyoom'
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
