# Declarative k3s node config, serialized verbatim to /etc/rancher/k3s/config.yaml.
# Keys mirror k3s CLI flags without the leading '--'; repeatable flags (like
# node-label) are lists. Node-specific, so set the concrete config in the
# policyfile. Do NOT put the node-token here -- it is a secret and stays in the
# manually-created k3s-agent.service.env.
default['k3s_agent']['config'] = {}

# Mount points the k3s-agent service must NOT start without. Rendered into a
# systemd drop-in as `RequiresMountsFor=`, which pulls each .mount unit in as a
# hard dependency and orders the agent after it. This is the host-side guard for
# `local` PVs / local-path volumes on `nofail` data disks: without it, a disk
# that failed to mount lets the kubelet serve the empty root-fs fallback dir, so
# a workload silently runs on empty data. With it, the agent waits for (or fails
# on) the mount instead -- while `nofail` still keeps the box booting and
# reachable. Empty by default (no drop-in written); set the list in the
# policyfile, typically to the cluster-storage mount points. Effective on the
# next agent start/boot -- applying it does not bounce the running agent.
default['k3s_agent']['required_mounts'] = []
