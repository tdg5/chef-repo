#!/bin/bash

set -e -o pipefail

if [ $EUID -ne 0 ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Install cinc workstation
# From: https://cinc.sh/start/workstation/
if ! `which knife`; then
  if [ `uname -s` = 'Darwin' -a `uname -m` = 'arm64' ]; then
    # For some reason the install can't find the right download on MacOS + ARM64
    curl -L https://omnitruck.cinc.sh/install.sh | sudo bash -s -- -P cinc-workstation -v 24 -l 'https://downloads.cinc.sh/files/stable/cinc-workstation/24.4.1064/mac_os_x/11/cinc-workstation-24.4.1064-1.arm64.dmg'
  else
    curl -L https://omnitruck.cinc.sh/install.sh | bash -s -- -P cinc-workstation -v 24
  fi
fi

# Install cinc client after cinc workstation since it often has newer versions
# of things than the workstation package. This may not be stable.

# Install cinc client
# From: https://cinc.sh/start/client/
if ! `which cinc-client`; then
  curl -L https://omnitruck.cinc.sh/install.sh | bash -s -- -v 18
fi
