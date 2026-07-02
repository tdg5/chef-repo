if platform?('mac_os_x')
  package 'ctags-exuberant'
else
  package 'exuberant-ctags'
end
