if node['platform_family'] == 'debian'
  apt_repository 'spotify' do
    components ['non-free']
    distribution 'stable'
    key 'https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg'
    uri 'http://repository.spotify.com'
  end
  package 'spotify-client'
elsif node['platform'] == 'mac_os_x'
  homebrew_cask 'spotify' do
    install_cask false
  end
end
