name 'swap'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Manage swap; disabling it for Kubernetes nodes'
long_description 'Manage swap. The disable recipe turns swap off and keeps it off, as required by the kubelet on k3s/Kubernetes nodes.'
version '0.0.1'

recipe 'swap', 'Does nothing.'
recipe 'swap::disable', 'Disables swap and removes it from /etc/fstab'

%w[ debian ubuntu ].each { |os| supports os }
