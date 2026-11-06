if platform?('mac_os_x')
  brew_cask 'gimp'
else
  %w(gimp gimp-gmic).each { |pkg| package pkg }
end
