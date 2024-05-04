name 'config'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Various configuration files and tweaks'
long_description  'Various configuration files and tweaks'
version           '0.0.1'

recipe 'config', 'noop'
recipe 'config::git', 'Installs user git config'
recipe 'config::mime_applications', 'Configure which applications to use for different MIME types'
recipe 'config::sshagent', 'Installs sshagent automatic ssh key loader script'
recipe 'config::tmux', 'Installs user tmux config'
recipe 'config::vim', 'Installs vim config'

%w[ debian ubuntu ].each { |os| supports os }
