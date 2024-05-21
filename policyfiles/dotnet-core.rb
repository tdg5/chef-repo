name 'dotnet-core'

default_source :supermarket

cookbook 'dotnet-core', path: '../cookbooks/dotnet-core'

run_list(
  'dotnet-core',
)
