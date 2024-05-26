name 'macos-packages'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install various packages on macos'
long_description  'Install various packages on macos'
version           '0.0.1'

recipe 'macos-packages', 'Noop'
recipe 'macos-packages::android-file-transfer', 'Install android-file-transfer package'

%w[ darwin ].each { |os| supports os }
