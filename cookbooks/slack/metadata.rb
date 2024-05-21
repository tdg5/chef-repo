name 'slack'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install slack via brew or deb'
long_description  'Install slack via brew or deb'
version           '0.0.1'

recipe 'slack', 'Install slack package'

%w[ darwin debian ubuntu ].each { |os| supports os }
