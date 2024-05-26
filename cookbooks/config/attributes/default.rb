nvm_path_by_platform = {
  'mac_os_x' => '/opt/homebrew/opt/nvm',
  'ubuntu' => ::File.join(node['user']['home_directory'], '.nvm'),
}
default['nvm']['path'] = nvm_path_by_platform[node['platform']]
