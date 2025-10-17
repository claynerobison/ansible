# Cloud-Init Setup for Ansible Pull Demo

This cloud-init configuration file (`cloud-init.yml`) automatically sets up an Ubuntu 24.04 LTS system to run the ansible-pull demo.

## What it does

1. **Updates the system** - Ensures all packages are current
2. **Installs minimal dependencies** - ansible, git
3. **Creates a runner script** - `/usr/local/bin/run-ansible-pull.sh`
4. **Runs initial demo** - Executes ansible-pull once during system setup
5. **Schedules recurring runs** - Sets up cron job to run every minute
6. **Prevents conflicts** - Uses lock files to prevent overlapping runs
7. **Logs everything** - All activity logged to `/var/log/ansible-pull.log`

## VMware Usage Instructions

### Method 1: Using the file during Ubuntu installation

1. **Download Ubuntu 24.04 LTS Server ISO**
   ```bash
   wget https://releases.ubuntu.com/24.04/ubuntu-24.04-live-server-amd64.iso
   ```

2. **Create VM in VMware**
   - Create new virtual machine
   - Select "Ubuntu 64-bit" as guest OS
   - Allocate appropriate resources (2+ GB RAM recommended)
   - Attach the Ubuntu ISO

3. **Boot and start installation**
   - Boot from ISO
   - Select "Install Ubuntu Server"
   - Follow installation prompts

4. **Provide cloud-init file during installation**
   - When prompted for "Cloud-init configuration" or in advanced options
   - Upload or paste the contents of `cloud-init.yml`
   - Or copy the file to a USB drive and mount during installation

### Method 2: Using cloud-init after installation

1. **Copy cloud-init file to the VM**
   ```bash
   scp cloud-init.yml user@vm-ip:/tmp/
   ```

2. **Apply cloud-init configuration**
   ```bash
   sudo cloud-init clean
   sudo cp /tmp/cloud-init.yml /etc/cloud/cloud.cfg.d/99-ansible-demo.cfg
   sudo cloud-init init
   sudo cloud-init modules --mode config
   sudo cloud-init modules --mode final
   ```

### Method 3: Using VMware vSphere/vCenter with OVF

1. **Create cloud-init ISO**
   ```bash
   # Create directory structure
   mkdir -p cloud-init-iso/
   
   # Copy user-data
   cp cloud-init.yml cloud-init-iso/user-data
   
   # Create meta-data file
   echo "instance-id: ansible-demo-vm" > cloud-init-iso/meta-data
   echo "local-hostname: ansible-demo" >> cloud-init-iso/meta-data
   
   # Create ISO
   genisoimage -output cloud-init.iso -volid cidata -joliet -rock cloud-init-iso/
   ```

2. **Attach ISO to VM as CD-ROM**
   - In VMware, add the cloud-init.iso as a CD-ROM drive
   - Boot the Ubuntu installation
   - Cloud-init will automatically detect and apply the configuration

## Customization Options

### SSH Access (Optional)
Uncomment and edit the `users` section if you need SSH access:
```yaml
users:
  - name: your-username
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yE... # Replace with your actual public key
```

### Repository URL
Change the repository URL in the script if using a fork:
```yaml
REPO_URL="https://github.com/your-username/ansible.git"
```

### Cron Schedule
Modify the cron schedule (currently every minute):
```yaml
# Every 5 minutes
- echo "*/5 * * * * root /usr/local/bin/run-ansible-pull.sh" >> /etc/crontab

# Every hour
- echo "0 * * * * root /usr/local/bin/run-ansible-pull.sh" >> /etc/crontab

# Every day at 6 AM
- echo "0 6 * * * root /usr/local/bin/run-ansible-pull.sh" >> /etc/crontab
```

## Monitoring

After the system boots, you can monitor the ansible-pull activity:

```bash
# Watch the log file
sudo tail -f /var/log/ansible-pull.log

# Check cron job status
sudo systemctl status cron

# Manually run ansible-pull
sudo /usr/local/bin/run-ansible-pull.sh

# Check if ansible-pull is currently running
ps aux | grep ansible-pull
```

## Troubleshooting

### Cloud-init not running
```bash
# Check cloud-init status
sudo cloud-init status

# View cloud-init logs
sudo journalctl -u cloud-init
sudo cat /var/log/cloud-init-output.log
```

### Ansible-pull issues
```bash
# Check the log file
sudo cat /var/log/ansible-pull.log

# Test ansible installation
ansible --version

# Test git connectivity
git ls-remote https://github.com/claynerobison/ansible.git
```

### Network issues
Ensure the VM has internet connectivity and can reach GitHub:
```bash
# Test connectivity
ping -c 4 github.com
curl -I https://github.com/claynerobison/ansible.git
```

## Security Notes

- The configuration runs ansible-pull as root for system configuration
- Lock files prevent multiple concurrent runs
- All activity is logged for audit purposes
- Consider using SSH keys instead of passwords for production use
- Review and customize the ansible playbook for your security requirements