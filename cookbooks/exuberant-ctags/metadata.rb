name 'exuberant-ctags'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Installs exuberant-ctags package'
version '0.0.1'

depends 'apt'

%w( mac_os_x debian ubuntu ).each { |os| supports os }
