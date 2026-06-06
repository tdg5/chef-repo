name 'nfs-server'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Installs the kernel NFS server and manages /etc/exports'
long_description 'Installs nfs-kernel-server and manages an attribute-driven set of NFS exports, re-exporting on change. Used to serve cluster-wide RWX persistent volumes off the bulk-storage disk.'
version '0.0.1'

recipe 'nfs-server', 'Installs nfs-kernel-server and manages exports'

%w[ debian ubuntu ].each { |os| supports os }
