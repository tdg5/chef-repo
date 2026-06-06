name 'cluster-storage'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Provision and mount a bulk-storage disk for cluster persistent volumes'
long_description 'Partitions, formats, and mounts a dedicated bulk-storage disk at a stable path for Kubernetes persistent volumes (local-path and NFS). The destructive partition/format steps are guarded so they only run on a blank disk.'
version '0.0.1'

recipe 'cluster-storage', 'Provisions and mounts the bulk-storage disk'

%w[ debian ubuntu ].each { |os| supports os }
