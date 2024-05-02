name 'noop'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Noop cookbook to be used when a run list must contain an item.'
long_description 'Noop cookbook to be used when a run list must contain an item. Does nothing.'
version '0.0.1'

recipe 'noop', 'Does nothing.'

%w[ debian ubuntu ].each { |os| supports os }
