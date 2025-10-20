#!/bin/bash

# Ansible Pull Demo Runner
set -e

REPO_URL="https://github.com/claynerobison/ansible.git"
PLAYBOOK="demo/local.yml"
LOGFILE="/var/log/ansible-pull.log"
LOCKFILE="/var/run/ansible-pull.lock"

# Prevent multiple instances from running
if [ -f "$LOCKFILE" ]; then
    echo "$(date): Ansible-pull already running, skipping..." >> "$LOGFILE"
    exit 0
fi

# Create lock file
touch "$LOCKFILE"

# Cleanup function
cleanup() {
    rm -f "$LOCKFILE"
}
trap cleanup EXIT

echo "$(date):************************ Starting ansible-pull" >> "$LOGFILE"

# Run ansible-pull
ansible-pull \
    --url "$REPO_URL" \
    --checkout main \
    --directory /tmp/ansible-pull \
    --inventory demo/inventory \
    --verbose \
    "$PLAYBOOK" >> "$LOGFILE" 2>&1 || true

echo "ansible-pull completed at $(date)**********************************"
echo " "
echo " "