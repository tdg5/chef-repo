# Helm 3 beside the default recipe's Helm 4, for charts and plugins that Helm 4
# breaks. Homebrew's helm@3 is keg-only, so it does not shadow `helm`; run it
# as /opt/homebrew/opt/helm@3/bin/helm.
if platform?('mac_os_x')
  package 'helm@3'
end
