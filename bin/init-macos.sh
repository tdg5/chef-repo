#!/bin/bash

set -e -o pipefail

if [ $EUID -ne 0 ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

ACTUAL_USER="$SUDO_USER"

if [ -z "$ACTUAL_USER" ]; then
  echo "Couldn't determine sudo user; aborting" 1>&2
  exit 2
fi

ACTUAL_USER_SAFE="$(echo -n "$ACTUAL_USER" | sed 's/\./_dot_/g')"

SUDOERS_D_DIR="/private/etc/sudoers.d"
ACTUAL_USER_SUDOERS_FILE_PATH="$SUDOERS_D_DIR/$ACTUAL_USER_SAFE"

if [ ! -f "$ACTUAL_USER_SUDOERS_FILE_PATH" ]; then
  echo "$ACTUAL_USER ALL = (ALL) NOPASSWD: ALL" | tee "$ACTUAL_USER_SUDOERS_FILE_PATH"
  chmod 0440 "$ACTUAL_USER_SUDOERS_FILE_PATH"
fi
