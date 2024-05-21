if node['platform_family'] == 'debian'
  apt_repository 'slack' do
    components ['main']
    distribution 'jessie'
    uri 'https://packagecloud.io/slacktechnologies/slack/debian'
  end
elsif node['platform'] == 'mac_os_x'
  homebrew_cask 'slack' do
    install_cask false
  end
end
