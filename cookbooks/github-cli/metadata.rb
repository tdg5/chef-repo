name 'github-cli'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install the GitHub CLI (gh) via brew or apt'
long_description  'Install the GitHub CLI (gh) via brew or apt'
version           '0.0.1'

recipe 'github-cli', 'Install the gh package'

%w[ darwin debian ubuntu ].each { |os| supports os }
