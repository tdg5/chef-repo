if node['platform_family'] == 'debian'
  apt_repository 'azure-cli' do
    components ['main']
    distribution node['lsb']['codename']
    key 'https://packages.microsoft.com/keys/microsoft.asc'
    uri 'https://packages.microsoft.com/repos/azure-cli/'
  end
end

package 'azure-cli'
