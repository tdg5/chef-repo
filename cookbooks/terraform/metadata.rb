name 'terraform'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install pre-compiled terraform binary'
long_description  'Install pre-compiled terraform binary'
version           '0.0.1'

recipe 'terraform', 'Install pre-compiled terraform binary'

%w[ darwin debian ubuntu ].each { |os| supports os }
