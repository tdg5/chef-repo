if node['platform'] == 'mac_os_x'
  homebrew_cask 'vlc' do
    install_cask false
  end
else
  package 'vlc'
end
