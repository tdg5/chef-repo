name 'docker-service'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Installs docker service via the docker cookbook'
long_description 'Installs docker service via the docker cookbook'
version '0.0.1'

depends 'docker'

recipe 'docker-service', 'Installs docker service'

%w[ debian ubuntu ].each { |os| supports os }
