#!/bin/bash

set -e -o pipefail

# From https://stackoverflow.com/a/4774063
REPO_DIR="$( cd -- "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"

NODE_NAME="$1"
if [ -z "$NODE_NAME" ]; then
  echo "Missing positional argument 1, NODE_NAME. Aborting." 1>&2
  exit 2
fi

EXPORT_DIR="$REPO_DIR/.cache/$NODE_NAME"
if [ -d "$EXPORT_DIR" ]; then
  sudo rm -rf "$EXPORT_DIR"
fi

cinc export "$REPO_DIR/policyfiles/$NODE_NAME.rb" "$EXPORT_DIR"

cd "$EXPORT_DIR"
sudo cinc-client -z
cd "$REPO_DIR"
sudo rm -rf "$EXPORT_DIR"
