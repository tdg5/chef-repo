name 'kube-prep'
maintainer 'Danny Guinther'
maintainer_email 'dannyguinther@gmail.com'
license 'MIT'
description 'Kernel modules and sysctls required by Kubernetes/k3s nodes'
long_description 'Loads the overlay and br_netfilter kernel modules (persisted across reboots) and sets the bridge-nf-call and ip_forward sysctls required by the kubelet and CNI.'
version '0.0.1'

recipe 'kube-prep', 'Loads kube kernel modules and sets kube sysctls'

%w[ debian ubuntu ].each { |os| supports os }
