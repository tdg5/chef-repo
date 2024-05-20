name 'spotify'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install spotify via brew or apt'
long_description  'Install spotify via brew or apt'
version           '0.0.1'

recipe 'spotify', 'Install spotify package'

%w[ darwin debian ubuntu ].each { |os| supports os }
