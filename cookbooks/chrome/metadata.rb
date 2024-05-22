name 'chrome'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Installs Google Chrome package'
long_description 'Installs Google Chrome package'
version '0.0.1'

recipe 'chrome', 'Installs Google Chrome package for deteced OS'
recipe 'chrome::debian', 'Installs Google Chrome package for debian'
recipe 'chrome::macos', 'Installs Google Chrome package for macos'

%w[ darwin debian ubuntu ].each { |os| supports os }
