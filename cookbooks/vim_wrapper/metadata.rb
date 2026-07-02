name 'vim_wrapper'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install vim via brew or apt'
version           '0.0.1'

depends 'vim'

%w( mac_os_x debian ubuntu ).each { |os| supports os }
