# Ansible Demo Playbook

This demo showcases how to use `ansible-pull` for local machine configuration.

## Files Structure

- `local.yml` - Main playbook that configures the local machine
- `inventory` - Inventory file for local execution
- `ansible.cfg` - Ansible configuration file

## Usage

### Method 1: Using the provided script
From the repository root:
```bash
./run-ansible-pull.sh
```

### Method 2: Direct ansible-pull command
```bash
ansible-pull -U https://github.com/claynerobison/ansible.git demo/local.yml
```

### Method 3: With specific options
```bash
ansible-pull \
    --url https://github.com/claynerobison/ansible.git \
    --checkout main \
    --directory /tmp/ansible-pull \
    --inventory demo/inventory \
    --verbose \
    demo/local.yml
```

## What the playbook does

1. Updates package cache (Ubuntu/Debian and RHEL/CentOS)

Note: Git must be pre-installed for ansible-pull to work (since it's needed to clone this repository).

## Requirements

- Ansible installed on the target machine
- Root/sudo access for system configuration
- Git access to the repository

## Testing locally

You can test the playbook locally without ansible-pull:

```bash
cd demo
ansible-playbook -i inventory local.yml --ask-become-pass
```