#!/bin/bash

set -e -o pipefail

if [ $EUID -ne 0 ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

if [[ ! "$(uname -a)" =~ "Ubuntu" ]]; then
  echo "This script is intended for ubuntu, but this doesn't seem to be ubuntu; aborting" 1>&2
  exit 2
fi

ACTUAL_USER="$SUDO_USER"

if [ -z "$ACTUAL_USER" ]; then
  echo "Couldn't determine sudo user; aborting" 1>&2
  exit 3
fi

ACTUAL_USER_SAFE="$(echo -n "$ACTUAL_USER" | sed 's/\./_dot_/g')"

SUDOERS_D_DIR="/etc/sudoers.d"
ACTUAL_USER_SUDOERS_FILE_PATH="$SUDOERS_D_DIR/$ACTUAL_USER_SAFE"

if [ ! -f "$ACTUAL_USER_SUDOERS_FILE_PATH" ]; then
  echo "$ACTUAL_USER ALL=NOPASSWD:ALL" | tee "$ACTUAL_USER_SUDOERS_FILE_PATH"
  chmod 0440 "$ACTUAL_USER_SUDOERS_FILE_PATH"
fi

for PKG in build-essential curl git; do
  $(dpkg -s $PKG > /dev/null 2>&1) || apt-get install -y $PKG
done

for USER_DIR in $HOME/src; do
  [ -d $USER_DIR ] || mkdir -p $USER_DIR
done

CHEF_REPO_PATH="$HOME/src/chef-repo"

[ -d "$CHEF_REPO_PATH" ] || git clone --recursive https://github.com/tdg5/chef-repo.git "$CHEF_REPO_PATH"

for USER_DIR in $HOME/src; do
  $(ls -altrd $USER_DIR | grep -q "$ACTUAL_USER $ACTUAL_USER") || chown -R $ACTUAL_USER:$ACTUAL_USER $USER_DIR
done

cd "$CHEF_REPO_PATH"

bin/install-cinc.sh
