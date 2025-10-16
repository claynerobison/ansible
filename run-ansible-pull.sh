#!/bin/bash

# Demo script for testing ansible-pull
# This script demonstrates how to use ansible-pull with this repository

set -e

REPO_URL="https://github.com/claynerobison/ansible.git"
PLAYBOOK="demo/local.yml"
LOGFILE="/var/log/ansible-pull.log"

echo "Starting ansible-pull at $(date)"

# Run ansible-pull
ansible-pull \
    --url "$REPO_URL" \
    --checkout main \
    --directory /tmp/ansible-pull \
    --inventory demo/inventory \
    --verbose \
    "$PLAYBOOK" 2>&1 | tee -a "$LOGFILE"

echo "ansible-pull completed at $(date)"