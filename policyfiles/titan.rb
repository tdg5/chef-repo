name 'titan'

default_source :supermarket

include_policy 'macos-base', path: '.'
include_policy 'kubernetes-client', path: '.'

cookbook 'brew-cask', path: '../cookbooks/brew-cask'
cookbook 'snowflake-snowsql', path: '../cookbooks/snowflake-snowsql'

run_list(
  'snowflake-snowsql'
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
