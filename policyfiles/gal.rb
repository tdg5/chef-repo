name 'gal'

default_source :supermarket

include_policy 'universal', path: '.'

run_list ['noop']

cookbook 'noop', path: '../cookbooks/noop'
