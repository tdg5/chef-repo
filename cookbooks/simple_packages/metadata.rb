name 'simple_packages'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Installs various simple packages'
long_description 'Installs various simple packages'
version '0.0.1'

depends 'apt'

recipe 'simple_packages', 'Noop'
recipe 'simple_packages::curl', 'Installs curl package'
recipe 'simple_packages::htop', 'Installs htop package'
recipe 'simple_packages::nautilus-dropbox', 'Installs nautilus-dropbox package'
recipe 'simple_packages::tmux', 'Installs tmux package'
recipe 'simple_packages::tree', 'Installs tree package'
recipe 'simple_packages::wmctrl', 'Installs wmctrl package'
recipe 'simple_packages::xsel', 'Installs xsel package'

%w[ debian ubuntu ].each { |os| supports os }
