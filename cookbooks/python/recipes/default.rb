if node['platform_family'] == 'debian'
  include_recipe 'python::deadsnakes'
  node['python']['versions'].each do |version|
    package "python#{version}"
    package "python#{version}-venv"
  end
elsif node['platform'] == 'mac_os_x'
  node['python']['versions'].each { |version| package "python@#{version}" }
end
