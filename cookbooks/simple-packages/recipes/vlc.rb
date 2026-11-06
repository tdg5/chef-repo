if platform?('mac_os_x')
  homebrew_cask 'vlc'
else
  package 'vlc'
end
