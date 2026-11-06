if platform_family?('debian')
  package 'firefox'
elsif platform?('mac_os_x')
  brew_cask 'firefox'
end
