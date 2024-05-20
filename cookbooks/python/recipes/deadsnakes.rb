if node['platform_family'] == 'debian'
  apt_repository 'deadsnakes' do
    uri 'ppa:deadsnakes/ppa'
  end
end
