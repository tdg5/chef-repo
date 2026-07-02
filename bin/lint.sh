#!/bin/bash

# Run cookstyle over the repo. Pass through any cookstyle args, e.g.
# `bin/lint.sh -a` to autocorrect. Uses the repo's .rubocop.yml automatically.

set -e -o pipefail

# From https://stackoverflow.com/a/4774063
REPO_DIR="$( cd -- "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"

if ! command -v cookstyle >/dev/null 2>&1; then
  echo 'cookstyle not found on PATH; install Cinc/Chef Workstation or run' 1>&2
  echo "'gem install cookstyle'." 1>&2
  exit 1
fi

cd "$REPO_DIR"
exec cookstyle --display-cop-names "$@"
