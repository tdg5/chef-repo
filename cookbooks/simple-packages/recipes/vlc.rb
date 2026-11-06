if platform?('mac_os_x')
  brew_cask 'vlc'
else
  package 'vlc'
end
