install_group = node['argocd']['install']['group']
install_prefix = node['argocd']['install']['prefix']
install_username = node['argocd']['install']['username']

# Prepare install path
directory 'argocd_install_prefix' do
  group install_group
  mode '0755'
  path install_prefix
  recursive true
  user install_username
end

version = node['argocd']['version']

download_url = (
  node['argocd']['download_url'] ||
  node['argocd']['download_url_template'] % {
    architecture: node['argocd']['architecture'],
    operating_system: node['argocd']['operating_system'],
    version: version,
  }
)

# Fetch the desired argocd version and put in install path
remote_file 'argocd' do
  action :create_if_missing
  group install_group
  mode '0755'
  path ::File.join(install_prefix, 'argocd')
  source download_url
  user install_username
end
