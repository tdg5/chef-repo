name 'claude-code'
maintainer 'Danny Guinther'
maintainer_email  'dannyguinther@gmail.com'
license           'MIT'
description       'Install the Claude Code CLI'
long_description  'Install the Claude Code CLI'
version           '0.0.1'

recipe 'claude-code', 'Install the Claude Code CLI'

%w[ darwin debian ubuntu ].each { |os| supports os }
