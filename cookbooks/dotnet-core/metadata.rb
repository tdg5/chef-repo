name 'dotnet-core'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install best available .NET Core'
long_description  'Install best available .NET Core'
version           '0.0.1'

recipe 'dotnet-core', 'Install best available .NET Core version'

%w[ darwin debian ubuntu ].each { |os| supports os }
