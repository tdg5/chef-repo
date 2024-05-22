name 'skype'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install skype via brew or apt'
long_description  'Install skype via brew or apt'
version           '0.0.1'

recipe 'skype', 'Install skype package'

%w[ darwin debian ubuntu ].each { |os| supports os }
