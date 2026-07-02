#!/bin/bash

# Point git at the repo's version-controlled hooks in .githooks/. Run once per
# clone. Uses core.hooksPath (git >= 2.9) so there are no symlinks to manage and
# the hooks stay under version control.

set -e -o pipefail

# From https://stackoverflow.com/a/4774063
REPO_DIR="$( cd -- "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"

git -C "$REPO_DIR" config core.hooksPath .githooks

echo 'Configured git to use hooks from .githooks/'
echo 'The pre-commit hook runs cookstyle on staged Ruby files.'
