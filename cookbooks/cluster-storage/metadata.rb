name 'cluster-storage'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Provision and mount storage disks for cluster persistent volumes'
long_description 'Partitions, formats, and mounts one or more dedicated storage disks (bulk HDDs, SSD tier) at stable paths for Kubernetes persistent volumes (local-path and NFS). Disks are declared as a list in the policyfile; the destructive partition/format steps are guarded so they only run on a blank disk.'
version '0.0.2'

recipe 'cluster-storage', 'Provisions and mounts the configured storage disks'

%w[ debian ubuntu ].each { |os| supports os }
