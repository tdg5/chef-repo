if node['platform_family'] == 'debian'
  packages = [
    "linux-headers-#{node['kernel']['release']}",
    'dkms',
    'virtualbox-dkms',
    'virtualbox-guest-additions-iso',
  ]
  packages.each { |package_name| package package_name }
end
