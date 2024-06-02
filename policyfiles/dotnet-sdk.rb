name 'dotnet-sdk'

default_source :supermarket

include_policy 'dotnet-core', path: '.'

cookbook 'vscode', path: '../cookbooks/vscode'

run_list(
  'vscode',
)
