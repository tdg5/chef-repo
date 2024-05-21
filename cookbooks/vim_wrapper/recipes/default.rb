if node['platform'] == 'mac_os_x'
  package 'vim'
else
  include_recipe 'vim'
end
