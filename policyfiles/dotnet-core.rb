name 'dotnet-core'

default_source :supermarket

cookbook 'brew-cask', path: '../cookbooks/brew-cask'
cookbook 'dotnet-core', path: '../cookbooks/dotnet-core'

run_list(
  'dotnet-core'
)
