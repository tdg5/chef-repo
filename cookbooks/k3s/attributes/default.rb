# Declarative k3s node config, serialized verbatim to /etc/rancher/k3s/config.yaml.
# Keys mirror k3s CLI flags without the leading '--'; repeatable flags (like
# node-label or disable) are lists. Node-specific, so set the concrete config in
# the policyfile. This is the node's ONLY source of k3s flags: the k3s_node
# resource strips any flags an installer left on the unit's ExecStart, because
# k3s does not de-duplicate a flag set in both places (a doubled node-ip reads
# as two IPs and the kubelet refuses to start). Do NOT put the join token or
# server URL here -- they are secrets / per-install, and stay in the
# manually-created k3s[-agent].service.env.
default['k3s']['config'] = {}

# Mount points the k3s service must NOT start without. Rendered into a systemd
# drop-in as `RequiresMountsFor=`, which pulls each .mount unit in as a hard
# dependency and orders the service after it. This is the host-side guard for
# `local` PVs / local-path volumes on `nofail` data disks: without it, a disk
# that failed to mount lets the kubelet serve the empty root-fs fallback dir, so
# a workload silently runs on empty data. With it, k3s waits for (or fails on)
# the mount instead -- while `nofail` still keeps the box booting and reachable.
# Empty by default (no drop-in written); set the list in the policyfile,
# typically to the cluster-storage mount points. Effective on the next k3s
# start/boot -- applying it does not bounce the running service.
default['k3s']['required_mounts'] = []
