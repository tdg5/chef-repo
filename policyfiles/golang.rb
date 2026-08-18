name 'golang'

default_source :supermarket

cookbook 'golang', path: '../cookbooks/golang'

run_list(
  'golang'
)
