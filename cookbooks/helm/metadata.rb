name 'helm'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install helm via brew or apt'
long_description  'Install helm via brew or apt'
version           '0.0.1'

recipe 'helm', 'Install helm package'

%w[ darwin debian ubuntu ].each { |os| supports os }
