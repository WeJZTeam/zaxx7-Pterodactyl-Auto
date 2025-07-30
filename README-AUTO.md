# Pterodactyl Auto Installer

This automated installer for Pterodactyl installs both Panel and Wings automatically with default settings. You only need to enter the username and password for the admin account.

## Features

- ✅ Automatic installation of Panel and Wings
- ✅ Default settings for all options
- ✅ Only requires username and password
- ✅ Automatic firewall configuration
- ✅ Secure random passwords for databases
- ✅ Installation in one command

## Requirements

- Linux operating system (Ubuntu 18.04+, Debian 9+, CentOS 7+)
- Internet connection
- Root privileges
- curl installed

## Usage

### Method 1: Direct Download and Run

```bash
curl -sSL https://raw.githubusercontent.com/zaxx7-Pterodactyl-Auto/pterodactyl-installer/master/install-auto.sh | bash
```

### Method 2: Download then Run

```bash
# Download the installer
curl -sSL -o install-auto.sh https://raw.githubusercontent.com/zaxx7-Pterodactyl-Auto/pterodactyl-installer/master/install-auto.sh

# Make the file executable
chmod +x install-auto.sh

# Run the installer
./install-auto.sh
```

## What Happens During Installation

1. **Admin Data Request**: You will be asked to enter:
   - Admin username
   - Admin password

2. **Default Settings**:
   - Database: `panel`
   - Database user: `pterodactyl`
   - Database password: random
   - Timezone: `Europe/Stockholm`
   - Email: `admin@localhost`
   - FQDN: Server IP automatically
   - Firewall configuration: enabled
   - SSL: disabled (can be configured later)

3. **Installation Process**:
   - Install Panel first
   - Then install Wings
   - Configure services automatically

## After Installation

After installation is complete, you can:

1. **Access the dashboard**: `http://YOUR_SERVER_IP`
2. **Login** using the admin credentials you entered
3. **Configure SSL** manually if you want HTTPS
4. **Add Nodes** in Wings

## Default Settings

| Setting | Default Value |
|---------|---------------|
| Database | panel |
| Database user | pterodactyl |
| Timezone | Europe/Stockholm |
| Email | admin@localhost |
| Firewall | enabled |
| SSL | disabled |
| FQDN | Server IP |

## Troubleshooting

### If Installation Fails

1. Check the error log: `cat /var/log/pterodactyl-installer.log`
2. Ensure you have an internet connection
3. Make sure you're running the command with root privileges
4. Verify that curl is installed

### If Services Don't Work

1. Check service status:
   ```bash
   systemctl status pterodactyl
   systemctl status wings
   ```

2. Restart services:
   ```bash
   systemctl restart pterodactyl
   systemctl restart wings
   ```

## Uninstallation

To uninstall, use the original installer:

```bash
curl -sSL https://raw.githubusercontent.com/pterodactyl-installer/pterodactyl-installer/master/install.sh | bash
```

Then select "Uninstall panel or wings".

## Support

If you encounter any issues, you can:
1. Review the error log
2. Open an issue on GitHub
3. Check the official Pterodactyl documentation

## License

This project is licensed under the GNU General Public License v3.0. 