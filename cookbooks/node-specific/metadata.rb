name 'node-specific'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Handle node-specific behaviors'
long_description  'Handle node-specific behaviors'
version           '0.0.1'

recipe 'node-specific', 'Noop'
recipe 'node-specific::crackbook', 'Host prep for crackbook (2016 MacBookPro13,1 k3s light worker)'
recipe 'node-specific::gal', 'Handle node-specific behaviors for gal'

%w[ debian ubuntu ].each { |os| supports os }
