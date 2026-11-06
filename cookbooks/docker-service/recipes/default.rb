if platform?('mac_os_x')
  brew_cask 'docker'
else
  docker_service 'default' do
    action [:create, :start]
  end
end
