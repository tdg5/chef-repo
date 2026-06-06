#!/bin/bash

set -e -o pipefail

# From https://stackoverflow.com/a/4774063
REPO_DIR="$( cd -- "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"

NODE_NAME="$1"
if [ -z "$NODE_NAME" ]; then
  echo "Missing positional argument 1, NODE_NAME. Aborting." 1>&2
  exit 2
fi

# Optional second argument enables cinc-client why-run (dry-run) mode, which
# reports what would converge without making changes.
CINC_CLIENT_ARGS=()
if [ -n "$2" ]; then
  case "$2" in
    --why-run|--dry-run|-W)
      CINC_CLIENT_ARGS+=(--why-run)
      ;;
    *)
      echo "Unknown option: $2. Supported: --why-run|--dry-run|-W" 1>&2
      exit 2
      ;;
  esac
fi

POLICY_FILE="$REPO_DIR/policyfiles/$NODE_NAME.rb"
if [ ! -f "$POLICY_FILE" ]; then
  echo "No policyfile at $POLICY_FILE. Aborting." 1>&2
  exit 2
fi

# Lockfiles are gitignored and generated per-host, so generate one if it's
# missing before exporting (which requires the lock).
LOCK_FILE="$REPO_DIR/policyfiles/$NODE_NAME.lock.json"
if [ ! -f "$LOCK_FILE" ]; then
  echo "No lockfile at $LOCK_FILE; generating it..."
  cinc install "$POLICY_FILE"
fi

EXPORT_DIR="$REPO_DIR/.cache/$NODE_NAME"
if [ -d "$EXPORT_DIR" ]; then
  sudo rm -rf "$EXPORT_DIR"
fi

cinc export "$POLICY_FILE" "$EXPORT_DIR"

cd "$EXPORT_DIR"
sudo cinc-client -z "${CINC_CLIENT_ARGS[@]}"
cd "$REPO_DIR"
sudo rm -rf "$EXPORT_DIR"
