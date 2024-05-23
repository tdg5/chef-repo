name 'azure-cli'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install azure-cli via brew or apt'
long_description  'Install azure-cli via brew or apt'
version           '0.0.1'

recipe 'azure-cli', 'Install azure-cli package'

%w[ darwin debian ubuntu ].each { |os| supports os }
