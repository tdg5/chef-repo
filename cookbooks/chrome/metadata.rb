name 'chrome'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Installs Google Chrome package'
version '0.0.1'

%w( mac_os_x debian ubuntu ).each { |os| supports os }
