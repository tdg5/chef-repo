if platform_family?('debian')
  include_recipe 'chrome::debian'
elsif platform?('mac_os_x')
  include_recipe 'chrome::macos'
end
