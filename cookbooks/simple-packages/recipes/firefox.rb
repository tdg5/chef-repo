if platform_family?('debian')
  package 'firefox'
elsif platform?('mac_os_x')
  homebrew_cask 'firefox' do
    install_cask false
  end
end
