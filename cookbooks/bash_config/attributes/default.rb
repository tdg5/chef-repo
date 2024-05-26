default['bash']['completion'] = [
  :git,
]

default['bash']['bashrc']['extra_sources'] = {}

completion_dir_by_platform = {
  'mac_os_x' => '/opt/homebrew/etc/bash_completion.d',
  'ubuntu' => '/etc/bash_completion.d',
}
default['bash']['completion_dir'] = completion_dir_by_platform[node['platform']]

nvm_path_by_platform = {
  'mac_os_x' => '/opt/homebrew/opt/nvm',
  'ubuntu' => ::File.join(node['user']['home_directory'], '.nvm'),
}
default['nvm']['path'] = nvm_path_by_platform[node['platform']]
