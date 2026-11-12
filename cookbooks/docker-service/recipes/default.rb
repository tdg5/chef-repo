if platform?('mac_os_x')
  brew_cask 'docker-desktop'
else
  docker_service 'default' do
    action [:create, :start]
  end
end
