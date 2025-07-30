#!/bin/bash

set -e

######################################################################################
#                                                                                    #
# Project 'pterodactyl-installer' - Automated Version                                #
#                                                                                    #
# Copyright (C) 2018 - 2024, Vilhelm Prytz, <vilhelm@prytznet.se>                    #
#                                                                                    #
#   This program is free software: you can redistribute it and/or modify             #
#   it under the terms of the GNU General Public License as published by             #
#   the Free Software Foundation, either version 3 of the License, or                #
#   (at your option) any later version.                                              #
#                                                                                    #
#   This program is distributed in the hope that it will be useful,                  #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of                   #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                    #
#   GNU General Public License for more details.                                     #
#                                                                                    #
#   You should have received a copy of the GNU General Public License                #
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.           #
#                                                                                    #
# https://github.com/pterodactyl-installer/pterodactyl-installer/blob/master/LICENSE #
#                                                                                    #
# This script is not associated with the official Pterodactyl Project.               #
# https://github.com/pterodactyl-installer/pterodactyl-installer                     #
#                                                                                    #
######################################################################################

GITHUB_SOURCE="v1.1.1"
SCRIPT_RELEASE="v1.1.1"
export GITHUB_BASE_URL="https://raw.githubusercontent.com/pterodactyl-installer/pterodactyl-installer"

LOG_PATH="/var/log/pterodactyl-installer.log"

# check for curl
if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required in order for this script to work."
  echo "* install using apt (Debian and derivatives) or yum/dnf (CentOS)"
  exit 1
fi

# Always remove lib.sh, before downloading it
[ -f /tmp/lib.sh ] && rm -rf /tmp/lib.sh
curl -sSL -o /tmp/lib.sh "$GITHUB_BASE_URL"/master/lib/lib.sh
# shellcheck source=lib/lib.sh
source /tmp/lib.sh

# Function to get user input for admin credentials
get_admin_credentials() {
    echo ""
    echo "=== Pterodactyl Auto Installer ==="
    echo "This installer will install Panel and Wings with default settings."
    echo "You only need to enter the admin username and password."
    echo ""
    
    # Get admin username
    while [ -z "$ADMIN_USERNAME" ]; do
        echo -n "* Enter admin username: "
        read -r ADMIN_USERNAME
        [ -z "$ADMIN_USERNAME" ] && echo "Username cannot be empty"
    done
    
    # Get admin password
    while [ -z "$ADMIN_PASSWORD" ]; do
        echo -n "* Enter admin password: "
        read -rs ADMIN_PASSWORD
        echo ""
        [ -z "$ADMIN_PASSWORD" ] && echo "Password cannot be empty"
    done
    
    # Confirm password
    echo -n "* Confirm admin password: "
    read -rs ADMIN_PASSWORD_CONFIRM
    echo ""
    
    if [ "$ADMIN_PASSWORD" != "$ADMIN_PASSWORD_CONFIRM" ]; then
        echo "Passwords do not match. Please try again."
        ADMIN_USERNAME=""
        ADMIN_PASSWORD=""
        get_admin_credentials
    fi
}

# Function to set default values for panel installation
setup_panel_defaults() {
    # Database configuration
    export MYSQL_DB="panel"
    export MYSQL_USER="pterodactyl"
    export MYSQL_PASSWORD=$(gen_passwd 64)
    
    # Environment
    export timezone="Europe/Stockholm"
    export email="admin@localhost"
    
    # Initial admin account
    export user_email="admin@localhost"
    export user_username="$ADMIN_USERNAME"
    export user_firstname="Admin"
    export user_lastname="User"
    export user_password="$ADMIN_PASSWORD"
    
    # SSL configuration
    export ASSUME_SSL=false
    export CONFIGURE_LETSENCRYPT=false
    
    # Firewall
    export CONFIGURE_FIREWALL=true
    
    # Get server IP for FQDN
    export FQDN=$(curl -s ifconfig.me)
    if [ -z "$FQDN" ]; then
        export FQDN="localhost"
    fi
}

# Function to set default values for wings installation
setup_wings_defaults() {
    # Install mariadb
    export INSTALL_MARIADB=false
    
    # Firewall
    export CONFIGURE_FIREWALL=true
    
    # SSL (Let's Encrypt)
    export CONFIGURE_LETSENCRYPT=false
    export FQDN=$(curl -s ifconfig.me)
    if [ -z "$FQDN" ]; then
        export FQDN="localhost"
    fi
    export EMAIL="admin@localhost"
    
    # Database host
    export CONFIGURE_DBHOST=false
    export CONFIGURE_DB_FIREWALL=false
    export MYSQL_DBHOST_HOST="127.0.0.1"
    export MYSQL_DBHOST_USER="pterodactyluser"
    export MYSQL_DBHOST_PASSWORD=$(gen_passwd 64)
}

# Function to install panel
install_panel() {
    echo ""
    echo "=== Installing Pterodactyl Panel ==="
    setup_panel_defaults
    
    # Run panel installer
    bash <(curl -sSL "$GITHUB_BASE_URL/$GITHUB_SOURCE/installers/panel.sh")
}

# Function to install wings
install_wings() {
    echo ""
    echo "=== Installing Pterodactyl Wings ==="
    setup_wings_defaults
    
    # Run wings installer
    bash <(curl -sSL "$GITHUB_BASE_URL/$GITHUB_SOURCE/installers/wings.sh")
}

# Main execution
main() {
    echo -e "\n\n* pterodactyl-auto-installer $(date) \n\n" >>$LOG_PATH
    
    # Get admin credentials
    get_admin_credentials
    
    # Check if we can detect an already existing installation
    if [ -d "/var/www/pterodactyl" ]; then
        warning "The script has detected that you already have Pterodactyl panel on your system!"
        echo -e -n "* Are you sure you want to proceed? (y/N): "
        read -r CONFIRM_PROCEED
        if [[ ! "$CONFIRM_PROCEED" =~ [Yy] ]]; then
            error "Installation aborted!"
            exit 1
        fi
    fi
    
    # Install panel
    install_panel |& tee -a $LOG_PATH
    
    # Install wings
    install_wings |& tee -a $LOG_PATH
    
    echo ""
    echo "=== Installation Complete ==="
    echo "Panel and Wings have been installed successfully!"
    echo "Panel URL: http://$FQDN"
    echo "Admin Username: $ADMIN_USERNAME"
    echo ""
    echo "Please configure your firewall and SSL certificates as needed."
}

# Run main function
main

# Remove lib.sh, so next time the script is run the newest version is downloaded.
rm -rf /tmp/lib.sh 