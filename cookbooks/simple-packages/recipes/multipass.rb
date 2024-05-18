if node['platform'] == 'mac_os_x'
  homebrew_cask 'multipass' do
    install_cask false
  end
end
