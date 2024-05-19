if node['platform_family'] == 'debian'
  apt_repository_version = node['kubectl']['apt_repository_version']
  apt_repository 'kubectl' do
    distribution '/'
    key "https://pkgs.k8s.io/core:/stable:/v#{apt_repository_version}/deb/Release.key"
    uri "https://pkgs.k8s.io/core:/stable:/v#{apt_repository_version}/deb/"
  end
end

package 'kubectl'
