#!/bin/bash

set -e -o pipefail

if [ $EUID -ne 0 ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

BIN_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

UNAME="$(uname -a)"

if [[ "$UNAME" =~ "Darwin" ]]; then
  $BIN_DIR/init-macos.sh
elif [[ "$UNAME" =~ "Ubuntu" ]]; then
  $BIN_DIR/init-ubuntu.sh
else
  echo "Could not determine OS; aborting" 1>&2
  exit 1
fi
