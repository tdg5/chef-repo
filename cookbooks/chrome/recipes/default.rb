if node['platform_family'] == 'debian'
  include_recipe 'chrome::debian'
elsif node['platform'] == 'mac_os_x'
  include_recipe 'chrome::macos'
end
