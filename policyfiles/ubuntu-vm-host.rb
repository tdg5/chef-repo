name 'ubuntu-vm-host'

default_source :supermarket

cookbook 'apt', '~> 7.5.17', :supermarket
cookbook 'simple-packages', path: '../cookbooks/simple-packages'

run_list(
  'apt',
  'simple-packages::libvirt-qemu',
)
