install_group = node['minikube']['install']['group']
install_prefix = node['minikube']['install']['prefix']
install_username = node['minikube']['install']['username']

# Prepare install path
directory 'minikube_install_prefix' do
  group install_group
  mode '0755'
  path install_prefix
  recursive true
  user install_username
end

version = node['minikube']['version']

download_url = (
  node['minikube']['download_url'] ||
  node['minikube']['download_url_template'] % {
    architecture: node['minikube']['architecture'],
    operating_system: node['minikube']['operating_system'],
    version: version,
  }
)

# Fetch the desired minikube version and put in install path
remote_file 'minikube' do
  action :create_if_missing
  group install_group
  mode '0755'
  path ::File.join(install_prefix, 'minikube')
  source download_url
  user install_username
end
