name 'universal'

default_source :supermarket

run_list(
  'apt',
  'htop',
)

cookbook 'apt', '~> 7.5.17', :supermarket
cookbook 'htop', path: '../cookbooks/htop'
