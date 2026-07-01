install_username = node['claude-code']['install']['username']
install_group = node['claude-code']['install']['group']
install_home = node['claude-code']['install']['home_directory']

version = node['claude-code']['version']
install_script_url = node['claude-code']['install_script_url']

# Claude Code has no apt/brew package -- the supported install path is its
# native installer, which drops a self-updating binary at ~/.local/bin/claude.
# Fetch the script and run it as the target user so the install lands in that
# user's home directory rather than root's.
binary_path = ::File.join(install_home, '.local', 'bin', 'claude')
script_path = ::File.join(Chef::Config['file_cache_path'], 'claude-code-install.sh')

remote_file 'claude_code_install_script' do
  action :create
  group install_group
  mode '0755'
  not_if { ::File.exist?(binary_path) }
  path script_path
  source install_script_url
  user install_username
end

execute 'install_claude_code' do
  command "#{script_path} #{version}"
  cwd install_home
  # Chef does not set HOME when dropping privileges, but the installer relies on
  # it to locate ~/.local/bin, so set it explicitly.
  environment('HOME' => install_home)
  group install_group
  not_if { ::File.exist?(binary_path) }
  user install_username
end
