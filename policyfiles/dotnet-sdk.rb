name 'dotnet-sdk'

default_source :supermarket

include_policy 'dotnet-core', path: '.'

cookbook 'brew-cask', path: '../cookbooks/brew-cask'
cookbook 'vscode', path: '../cookbooks/vscode'

run_list(
  'vscode'
)
