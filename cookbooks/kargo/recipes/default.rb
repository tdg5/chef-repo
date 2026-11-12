install_group = node['kargo']['install']['group']
install_prefix = node['kargo']['install']['prefix']
install_username = node['kargo']['install']['username']

# Prepare install path
directory 'kargo_install_prefix' do
  group install_group
  mode '0755'
  path install_prefix
  recursive true
  user install_username
end

version = node['kargo']['version']

download_url = node['kargo']['download_url'] ||
               format(node['kargo']['download_url_template'], architecture: node['kargo']['architecture'], operating_system: node['kargo']['operating_system'], version: version)

# Fetch the desired kargo version and put in install path
remote_file 'kargo' do
  action :create_if_missing
  group install_group
  mode '0755'
  path ::File.join(install_prefix, 'kargo')
  source download_url
  user install_username
end
