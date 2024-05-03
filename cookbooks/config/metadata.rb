name 'config'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Various configuration files and tweaks'
long_description  'Various configuration files and tweaks'
version           '0.0.1'

recipe 'config', 'noop'
recipe 'config:git', 'Installs user git config'

%w[ debian ubuntu ].each { |os| supports os }
