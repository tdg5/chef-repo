if node['platform'] == 'mac_os_x'
  homebrew_cask 'visual-studio-code' do
    install_cask false
  end
end
