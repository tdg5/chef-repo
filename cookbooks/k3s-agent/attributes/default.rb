# Declarative k3s node config, serialized verbatim to /etc/rancher/k3s/config.yaml.
# Keys mirror k3s CLI flags without the leading '--'; repeatable flags (like
# node-label) are lists. Node-specific, so set the concrete config in the
# policyfile. Do NOT put the node-token here -- it is a secret and stays in the
# manually-created k3s-agent.service.env.
default['k3s_agent']['config'] = {}
