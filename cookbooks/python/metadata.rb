name 'python'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install python versions via brew or apt'
long_description  'Install python versions via brew or apt'
version           '0.0.1'

recipe 'python', 'Install selected python versions'
recipe 'python::deadsnakes', 'Install the deadsnakes apt repository'

%w[ darwin debian ubuntu ].each { |os| supports os }
