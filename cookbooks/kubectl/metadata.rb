name 'kubectl'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install kubectl via brew or apt'
long_description  'Install kubectl via brew or apt'
version           '0.0.1'

recipe 'kubectl', 'Install kubectl package'

%w[ darwin debian ubuntu ].each { |os| supports os }
