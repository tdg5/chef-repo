if platform_family?('debian')
  apt_repository 'slack' do
    components ['main']
    distribution 'jessie'
    uri 'https://packagecloud.io/slacktechnologies/slack/debian'
  end
elsif platform?('mac_os_x')
  brew_cask 'slack'
end
