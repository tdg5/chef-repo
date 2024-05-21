name 'minikube'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install pre-compiled minikube binary'
long_description  'Install pre-compiled minikube binary'
version           '0.0.1'

recipe 'minikube', 'Install pre-compiled minikube binary'

%w[ darwin debian ubuntu ].each { |os| supports os }
