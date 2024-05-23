name 'shadow'

default_source :supermarket

include_policy 'macos-base', path: '.'
include_policy 'kubernetes-client', path: '.'
include_policy 'dotnet-sdk', path: '.'

cookbook 'azure-cli', path: '../cookbooks/azure-cli'

run_list(
  'azure-cli',
)

username = 'danny'
group = 'staff'

default['user'] = {
  email: 'danny@phave.com',
  group: group,
  home_directory: '/Users/danny',
  username: username,
}

default['root_user'] = {
  group: 'admin',
  username: 'root',
}
