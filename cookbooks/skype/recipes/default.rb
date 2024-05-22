if node['platform'] == 'mac_os_x'
  homebrew_cask 'skype' do
    install_cask false
  end
end
