name 'simple-packages'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Installs various simple packages'
version '0.0.1'

depends 'apt'

%w( debian mac_os_x ubuntu ).each { |os| supports os }
