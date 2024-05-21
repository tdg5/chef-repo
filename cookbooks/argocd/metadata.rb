name 'argocd'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install pre-compiled argocd binary'
long_description  'Install pre-compiled argocd binary'
version           '0.0.1'

recipe 'argocd', 'Install pre-compiled argocd binary'

%w[ darwin debian ubuntu ].each { |os| supports os }
