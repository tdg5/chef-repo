if node['platform_family'] == 'debian'
  architecture = node['kernel']['machine']
  qemu_package = (
    if architecture == 'x86_64'
      'qemu-system-x86'
    elsif architecture == 'aarch64' || architecture == 'arm64'
      'qemu-system-arm'
    else
      raise RuntimeError("Could not determine qemu package for architecture=#{architecture}")
    end
  )
  packages = [
    qemu_package,
    'qemu-utils',
    'libvirt-clients',
    'libvirt-clients-qemu',
    'libvirt-daemon',
    'libvirt-daemon-driver-qemu',
  ]
  packages.each { |package_name| package package_name }
end
