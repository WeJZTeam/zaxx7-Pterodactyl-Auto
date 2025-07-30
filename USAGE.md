# How to Use the Pterodactyl Auto Installer

## Added Files

The following files have been created to facilitate the installation process:

1. **`install-auto.sh`** - Complete auto installer
2. **`one-liner.sh`** - Simplified version for direct execution
3. **`README-AUTO.md`** - Detailed usage guide

## Method 1: Using the Complete Auto Installer

```bash
# Download the installer
curl -sSL -o install-auto.sh https://raw.githubusercontent.com/zaxx7-Pterodactyl-Auto/pterodactyl-installer/master/install-auto.sh

# Make the file executable
chmod +x install-auto.sh

# Run the installer
./install-auto.sh
```

## Method 2: Direct Execution (One-liner)

```bash
curl -sSL https://raw.githubusercontent.com/zaxx7-Pterodactyl-Auto/pterodactyl-installer/master/one-liner.sh | bash
```

## What Happens During Installation

### 1. Admin Data Request
The installer will ask you to enter:
- **Admin username**: such as `admin`
- **Admin password**: a strong password

### 2. Default Settings
All settings will be automatically configured:

| Setting | Default Value |
|---------|---------------|
| Database | `panel` |
| Database user | `pterodactyl` |
| Database password | random (64 characters) |
| Timezone | `Europe/Stockholm` |
| Email | `admin@localhost` |
| FQDN | Server IP automatically |
| Firewall | enabled |
| SSL | disabled |

### 3. Installation Process
1. Install Panel first
2. Install Wings
3. Configure services automatically

## After Installation

### Access the Dashboard
```
http://YOUR_SERVER_IP
```

### Login
- **Username**: what you entered during installation
- **Password**: what you entered during installation

## Additional Settings (Optional)

### SSL Setup
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d your-domain.com
```

### Firewall Setup
```bash
# Open required ports
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 2022/tcp
sudo ufw allow 25565/tcp
```

## Troubleshooting

### Error Log
```bash
cat /var/log/pterodactyl-installer.log
```

### Service Status
```bash
systemctl status pterodactyl
systemctl status wings
```

### Restart Services
```bash
systemctl restart pterodactyl
systemctl restart wings
```

## Features

✅ **Easy to use**: One command only  
✅ **Default settings**: No complex configuration needed  
✅ **Security**: Random passwords for databases  
✅ **Speed**: Fast and direct installation  
✅ **Complete**: Install Panel and Wings together  

## Important Notes

1. **Root privileges**: Make sure to run the command with root privileges
2. **Internet connection**: Stable internet connection required
3. **Operating system**: Works on Ubuntu 18.04+, Debian 9+, CentOS 7+
4. **Backup**: Keep a backup of important data

## Support

If you encounter any problems:
1. Check the error log
2. Verify the requirements
3. Check the official Pterodactyl documentation 