name 'skype'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install skype via brew or apt'
version           '0.0.1'

%w( mac_os_x debian ubuntu ).each { |os| supports os }
