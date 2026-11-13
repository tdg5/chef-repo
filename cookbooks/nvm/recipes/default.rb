# Install nvm for the user, then install node['nvm']['node_version'] with it
# and make that the default. The shell configs (bash_config, config::zsh)
# source nvm from ~/.nvm on Linux and from Homebrew's prefix on macOS.
username = node['user']['username']
user_group = node['user']['group']
user_home_directory = node['user']['home_directory']
nvm_directory = ::File.join(user_home_directory, '.nvm')

if platform?('mac_os_x')
  package 'nvm'

  # Homebrew's nvm keeps its scripts in its prefix and the installed Node
  # versions in NVM_DIR, which it expects the user to create.
  directory nvm_directory do
    group user_group
    owner username
  end

  nvm_sh_path = '/opt/homebrew/opt/nvm/nvm.sh'
else
  git nvm_directory do
    group user_group
    repository 'https://github.com/nvm-sh/nvm.git'
    revision node['nvm']['version']
    user username
  end

  nvm_sh_path = ::File.join(nvm_directory, 'nvm.sh')
end

node_version = node['nvm']['node_version']
default_alias_path = ::File.join(nvm_directory, 'alias', 'default')

execute "nvm install node #{node_version}" do
  command %(bash -c 'source "#{nvm_sh_path}" && nvm install #{node_version} && nvm alias default #{node_version}')
  environment('HOME' => user_home_directory, 'NVM_DIR' => nvm_directory)
  group user_group
  user username
  not_if do
    ::File.directory?(::File.join(nvm_directory, 'versions', 'node', "v#{node_version}")) &&
      ::File.exist?(default_alias_path) &&
      ::File.read(default_alias_path).strip == node_version
  end
end
