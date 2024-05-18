if node['platform'] == 'mac_os_x'
  homebrew_cask 'gimp' do
    install_cask false
  end
else
  %w[gimp gimp-gmic].each { |pkg| package pkg }
end
