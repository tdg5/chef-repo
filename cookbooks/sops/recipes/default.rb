install_group = node['sops']['install']['group']
install_prefix = node['sops']['install']['prefix']
install_username = node['sops']['install']['username']

# Prepare install path
directory 'sops_install_prefix' do
  group install_group
  mode '0755'
  path install_prefix
  recursive true
  user install_username
end

version = node['sops']['version']

download_url = (
  node['sops']['download_url'] ||
  node['sops']['download_url_template'] % {
    architecture: node['sops']['architecture'],
    operating_system: node['sops']['operating_system'],
    version: version,
  }
)

# Fetch the desired sops version and put in install path
remote_file 'sops' do
  action :create_if_missing
  group install_group
  mode '0755'
  path ::File.join(install_prefix, 'sops')
  source download_url
  user install_username
end
