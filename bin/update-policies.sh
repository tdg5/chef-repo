#!/bin/bash

# Usage: update-policies.sh [POLICY_NAME...]
#
# With no arguments, updates the lock file of every policy in policyfiles/.
# With one or more policy names (e.g. "titan"), updates only those policies and
# the policies they include, directly or transitively, dependencies first.

set -e -o pipefail

# From https://stackoverflow.com/a/4774063
REPO_DIR="$( cd -- "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"

POLICY_FILES_DIR="$REPO_DIR/policyfiles"

# Prints the names of the policies a policy file includes, one per line
included_policy_names() {
  sed -nE "s/^[[:space:]]*include_policy[[:space:]]+['\"]([^'\"]+)['\"].*/\1/p" "$1"
}

if [ $# -eq 0 ]; then
  REMAINING_POLICY_FILES=$(find "$POLICY_FILES_DIR" -name '*.rb')
else
  # Collect the requested policies plus everything they include
  PENDING_POLICY_NAMES="$*"
  SELECTED_POLICY_FILES=""
  while [ -n "$PENDING_POLICY_NAMES" ]; do
    set -- $PENDING_POLICY_NAMES
    POLICY_NAME=$(basename -s .rb "$1")
    shift
    PENDING_POLICY_NAMES="$*"

    POLICY_FILE="$POLICY_FILES_DIR/$POLICY_NAME.rb"
    if echo "$SELECTED_POLICY_FILES" | grep -qxF "$POLICY_FILE"; then
      continue
    fi
    if [ ! -f "$POLICY_FILE" ]; then
      echo "Unknown policy: $POLICY_NAME (no $POLICY_FILE)" 1>&2
      exit 1
    fi

    SELECTED_POLICY_FILES="$SELECTED_POLICY_FILES$POLICY_FILE
"
    PENDING_POLICY_NAMES="$PENDING_POLICY_NAMES $(included_policy_names "$POLICY_FILE" | tr '\n' ' ')"
    PENDING_POLICY_NAMES=$(echo "$PENDING_POLICY_NAMES" | xargs)
  done
  REMAINING_POLICY_FILES=$(printf '%s' "$SELECTED_POLICY_FILES")
fi

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
    # This is elaborate because grep -v exits with status code 1 if no files with
    # matches are found which is expected when all dependencies have been resolved
    REMAINING_POLICY_FILES=$(
      {
        echo "$REMAINING_POLICY_FILES" | grep -v "$POLICY_FILE"
      } || true
    )
  done
done
