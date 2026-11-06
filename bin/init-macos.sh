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

# The homebrew cookbook cannot install Homebrew on a Mac that lacks it (its
# owner lookup fails before `brew` exists), so install it here. Homebrew's
# installer refuses to run as root, so it runs as the sudo user, whose
# passwordless sudo entry above lets it escalate without prompting.
if [ ! -x /opt/homebrew/bin/brew ] && [ ! -x /usr/local/bin/brew ]; then
  read -r -p "Homebrew is not installed. Install it now? [y/N] " INSTALL_HOMEBREW < /dev/tty
  case "$INSTALL_HOMEBREW" in
    [yY]|[yY][eE][sS])
      HOMEBREW_INSTALLER="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      sudo -u "$ACTUAL_USER" -H env NONINTERACTIVE=1 /bin/bash -c "$HOMEBREW_INSTALLER"
      ;;
    *)
      echo "Skipping Homebrew; the macOS policies need it before they converge." 1>&2
      ;;
  esac
fi
