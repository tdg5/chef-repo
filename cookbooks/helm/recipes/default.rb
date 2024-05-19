if node['platform_family'] == 'debian'
  apt_repository 'helm' do
    components ['main']
    distribution 'all'
    key 'https://baltocdn.com/helm/signing.asc'
    uri 'https://baltocdn.com/helm/stable/debian/'
  end
end

package 'helm'
