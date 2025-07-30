#!/bin/bash
# One-liner Pterodactyl Auto Installer (Fixed Version)
# Usage: curl -sSL https://raw.githubusercontent.com/WeJZTeam/zaxx7-Pterodactyl-Auto/main/one-liner-fixed.sh | bash

set -e

echo "=== Pterodactyl Auto Installer ==="
echo "This will install Pterodactyl Panel and Wings with default settings."
echo "You only need to provide admin username and password."
echo ""

# Get admin credentials
while [ -z "$ADMIN_USERNAME" ]; do
    echo -n "* Enter admin username: "
    read -r ADMIN_USERNAME
    if [ -z "$ADMIN_USERNAME" ]; then
        echo "Username cannot be empty"
    fi
done

while [ -z "$ADMIN_PASSWORD" ]; do
    echo -n "* Enter admin password: "
    read -rs ADMIN_PASSWORD
    echo ""
    if [ -z "$ADMIN_PASSWORD" ]; then
        echo "Password cannot be empty"
    fi
done

echo -n "* Confirm admin password: "
read -rs ADMIN_PASSWORD_CONFIRM
echo ""

if [ "$ADMIN_PASSWORD" != "$ADMIN_PASSWORD_CONFIRM" ]; then
    echo "Passwords do not match. Please run the script again."
    exit 1
fi

echo ""
echo "Starting installation..."

# Set default values
export MYSQL_DB="panel"
export MYSQL_USER="pterodactyl"
export MYSQL_PASSWORD=$(openssl rand -base64 32 2>/dev/null || echo "randompassword123")
export timezone="Europe/Stockholm"
export email="admin@localhost"
export user_email="admin@localhost"
export user_username="$ADMIN_USERNAME"
export user_firstname="Admin"
export user_lastname="User"
export user_password="$ADMIN_PASSWORD"
export ASSUME_SSL=false
export CONFIGURE_LETSENCRYPT=false
export CONFIGURE_FIREWALL=true
export FQDN=$(curl -s ifconfig.me 2>/dev/null || echo "localhost")

# Download and run panel installer
echo "Installing Panel..."
bash <(curl -sSL https://raw.githubusercontent.com/pterodactyl-installer/pterodactyl-installer/master/installers/panel.sh)

# Download and run wings installer
echo "Installing Wings..."
bash <(curl -sSL https://raw.githubusercontent.com/pterodactyl-installer/pterodactyl-installer/master/installers/wings.sh)

echo ""
echo "=== Installation Complete ==="
echo "Panel and Wings have been installed successfully!"
echo "Panel URL: http://$FQDN"
echo "Admin Username: $ADMIN_USERNAME"
echo ""
echo "Please configure your firewall and SSL certificates as needed." 