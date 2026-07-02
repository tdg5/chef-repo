if platform_family?('debian')
  package 'nautilus-dropbox'
elsif platform?('mac_os_x')
  homebrew_cask 'dropbox' do
    install_cask false
  end
end
