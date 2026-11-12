name 'titan'

default_source :supermarket

include_policy 'macos-base', path: '.'
include_policy 'kubernetes-client', path: '.'

cookbook 'brew-cask', path: '../cookbooks/brew-cask'
cookbook 'simple-packages', path: '../cookbooks/simple-packages'
cookbook 'snowflake-snowsql', path: '../cookbooks/snowflake-snowsql'

run_list(
  'snowflake-snowsql',
  'simple-packages::tflint',
  'simple-packages::postgresql',
  'simple-packages::libpq',
  'simple-packages::mailpit',
  'simple-packages::cmatrix',
  'simple-packages::telnet',
  'simple-packages::ghostty',
  'simple-packages::gcloud-cli',
  'simple-packages::ngrok',
  'simple-packages::stats'
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
