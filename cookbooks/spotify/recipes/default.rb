if platform_family?('debian')
  apt_repository 'spotify' do
    components ['non-free']
    distribution 'stable'
    key 'https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg'
    uri 'http://repository.spotify.com'
  end
  package 'spotify-client'
elsif platform?('mac_os_x')
  brew_cask 'spotify'
end
