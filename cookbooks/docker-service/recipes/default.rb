if node['platform'] == 'mac_os_x'
  homebrew_cask 'docker' do
    install_cask false
  end
else
  docker_service 'default' do
    action [:create, :start]
  end
end
