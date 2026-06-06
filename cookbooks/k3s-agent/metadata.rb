name 'k3s-agent'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Manages declarative k3s agent node config (/etc/rancher/k3s/config.yaml)'
long_description 'Manages the k3s agent node configuration file (labels and other node config) and keeps the k3s-agent service enabled. The k3s install and the node-token remain a documented manual step (the token is a secret).'
version '0.0.1'

recipe 'k3s-agent', 'Manages /etc/rancher/k3s/config.yaml and the k3s-agent service'

%w[ debian ubuntu ].each { |os| supports os }
