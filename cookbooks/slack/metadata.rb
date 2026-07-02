name 'slack'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install slack via brew or deb'
version           '0.0.1'

%w( mac_os_x debian ubuntu ).each { |os| supports os }
