if platform?('mac_os_x')
  homebrew_cask 'docker'
else
  docker_service 'default' do
    action [:create, :start]
  end
end
