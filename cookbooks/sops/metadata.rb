name 'sops'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install pre-compiled sops binary'
long_description  'Install pre-compiled sops binary'
version           '0.0.1'

recipe 'sops', 'Install pre-compiled sops binary'

%w[ darwin debian ubuntu ].each { |os| supports os }
