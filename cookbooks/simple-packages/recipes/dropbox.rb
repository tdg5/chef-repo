if platform_family?('debian')
  package 'nautilus-dropbox'
elsif platform?('mac_os_x')
  brew_cask 'dropbox'
end
