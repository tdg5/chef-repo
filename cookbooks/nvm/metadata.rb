name 'nvm'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install nvm and a default Node.js version for the user'
version           '0.0.1'

%w( mac_os_x debian ubuntu ).each { |os| supports os }
