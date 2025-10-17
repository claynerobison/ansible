# Ansible Demo Repository

This repository contains a demo Ansible playbook designed to work with `ansible-pull` for local machine configuration.

## Quick Start

Run the demo playbook using ansible-pull:

```bash
# Using the provided script
./run-ansible-pull.sh

# Or directly with ansible-pull
ansible-pull -U https://github.com/claynerobison/ansible.git demo/local.yml
```

## Repository Structure

- `demo/` - Demo playbook and related files
  - `local.yml` - Main playbook for local machine configuration
  - `inventory` - Local inventory file
  - `ansible.cfg` - Ansible configuration
  - `README.md` - Detailed demo documentation
- `run-ansible-pull.sh` - Helper script to run ansible-pull
- `LICENSE` - License file
- `README.md` - This file

## What the Demo Does

The demo playbook showcases essential automation tasks:

- Package cache updates across platforms (apt/yum)

## Requirements

- Ansible installed on the target machine
- Git installed (required for ansible-pull to clone repository)
- Root/sudo access for system configuration
- Network access to this repository

For detailed usage instructions, see [demo/README.md](demo/README.md).
