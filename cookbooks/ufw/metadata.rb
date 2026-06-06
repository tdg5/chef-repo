name 'ufw'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Default-deny host firewall via ufw with LAN-scoped allow rules'
long_description 'Installs and configures ufw with a default-deny inbound policy and an attribute-driven list of allow rules scoped to the LAN/cluster CIDR. Default-deny covers any routable IPv6 on the host.'
version '0.0.1'

recipe 'ufw', 'Configures and enables ufw'

%w[ debian ubuntu ].each { |os| supports os }
