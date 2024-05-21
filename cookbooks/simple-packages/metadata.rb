name 'simple-packages'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Installs various simple packages'
long_description 'Installs various simple packages'
version '0.0.1'

depends 'apt'

recipe 'simple-packages', 'Noop'
recipe 'simple-packages::cmake', 'Installs cmake package'
recipe 'simple-packages::curl', 'Installs curl package'
recipe 'simple-packages::htop', 'Installs htop package'
recipe 'simple-packages::multipass', 'Installs multipass package'
recipe 'simple-packages::nautilus-dropbox', 'Installs nautilus-dropbox package'
recipe 'simple-packages::tmux', 'Installs tmux package'
recipe 'simple-packages::tree', 'Installs tree package'
recipe 'simple-packages::vlc', 'Installs vlc package'
recipe 'simple-packages::wmctrl', 'Installs wmctrl package'
recipe 'simple-packages::xsel', 'Installs xsel package'

%w[ debian ubuntu ].each { |os| supports os }
