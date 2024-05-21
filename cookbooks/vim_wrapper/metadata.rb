name 'vim_wrapper'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install vim via brew or apt'
long_description  'Install vim via brew or apt'
version           '0.0.1'

recipe 'helm', 'Install vim package'

depends 'vim'

%w[ darwin debian ubuntu ].each { |os| supports os }
