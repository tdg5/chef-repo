name 'dotnet-core'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install best available .NET Core'
version           '0.0.1'

%w( mac_os_x debian ubuntu ).each { |os| supports os }
