name 'vscode'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install Visual Studio Code'
long_description  'Install Visual Studio Code'
version           '0.0.1'

recipe 'vscode', 'Install Visual Studio Code'

%w[ darwin ].each { |os| supports os }
