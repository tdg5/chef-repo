#!/bin/bash

set -e -o pipefail

# From https://stackoverflow.com/a/4774063
REPO_DIR="$( cd -- "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"

POLICY_FILES_DIR="$REPO_DIR/policyfiles"

REMAINING_POLICY_FILES=$(find "$POLICY_FILES_DIR" -name '*.rb')

POLICY_FILES_COUNT=$(echo "$REMAINING_POLICY_FILES" | wc -l | tr -d ' ')

echo "Updating $POLICY_FILES_COUNT policies..."

POLICY_FILES_UPDATED_COUNT=0

# Rudimentary dependency resolution algorithm that just checks every candidate
# every round to see which candidates have no more dependencies remaining. Does
# not handle missing dependencies, expects cinc to notice missing policies.
while [ -n "$REMAINING_POLICY_FILES" ]; do
  REMAINING_POLICY_NAMES_PATTERN=$(
    echo -n "$REMAINING_POLICY_FILES" |
    xargs basename -s .rb |
    tr '\n' '|' |
    sed -e 's/|$//'
  )
  QUOTES='"'"'"
  EXCLUSION_PATTERN="include_policy [^,]*[$QUOTES]($REMAINING_POLICY_NAMES_PATTERN)[$QUOTES]"

  # This is elaborate because grep -L exits with status code 1 if no files with
  # matches are found which is expected when all dependencies have been resolved
  ELIGIBLE_POLICY_FILES=$(
    {
      echo "$REMAINING_POLICY_FILES" | xargs grep -EL "$EXCLUSION_PATTERN"
    } || true
  )

  if [ -z "$ELIGIBLE_POLICY_FILES" ]; then
    echo 'Encountered cyclical dependency before all policies were updated' 1>&2
    echo "Policies that couldn't be updated:" 1>&2
    echo "$REMAINING_POLICY_FILES" 1>&2
    exit 1
  fi

  for POLICY_FILE in $ELIGIBLE_POLICY_FILES; do
    POLICY_FILES_UPDATED_COUNT=$(($POLICY_FILES_UPDATED_COUNT + 1))
    echo "[$POLICY_FILES_UPDATED_COUNT/$POLICY_FILES_COUNT] Updating $POLICY_FILE"
    cinc update "$POLICY_FILE"
    REMAINING_POLICY_FILES=$(echo "$REMAINING_POLICY_FILES" | grep -v "$POLICY_FILE")
  done
done
