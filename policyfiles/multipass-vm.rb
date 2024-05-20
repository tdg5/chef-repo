name 'multipass-vm'

default_source :supermarket

cookbook 'config', path: '../cookbooks/config'

run_list(
  'config::timesyncd',
)
