name 'ksops'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install pre-compiled ksops binary'
long_description  'Install pre-compiled ksops binary'
version           '0.0.1'

recipe 'ksops', 'Install pre-compiled ksops binary'

%w[ darwin debian ubuntu ].each { |os| supports os }
