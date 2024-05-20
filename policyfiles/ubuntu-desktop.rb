name 'ubuntu-desktop'

default_source :supermarket

include_policy 'ubuntu-base', path: '.'

cookbook 'apt', '~> 7.5.17', :supermarket
cookbook 'chrome', path: '../cookbooks/chrome'
cookbook 'config', path: '../cookbooks/config'
cookbook 'simple-packages', path: '../cookbooks/simple-packages'
cookbook 'spotify', path: '../cookbooks/spotify'

run_list(
  'apt',
  'simple-packages::wmctrl',
  'simple-packages::xsel',
  'simple-packages::gimp',
  'simple-packages::jhead',
  'simple-packages::vlc',
  'chrome',
  'config::mime_applications',
  'simple-packages::nautilus-dropbox',
  'spotify',
)
