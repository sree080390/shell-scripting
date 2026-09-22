#!/bin/bash

USER_ID=$(id -u)
INSTALL_LOGS_FILE="/var/log/shell-script.log"
STATUS_LOGS_FILE="/var/log/shell-script-status.log"
read -p "Enter the server to be installed (e.g., httpd, nginx): " SERVER_TO_BE_INSTALLED
if [ $USER_ID -ne 0 ]; then
    echo "You are not root user. Please run the script as root."
    exit 1
fi
echo "You are root user. Proceeding with the script execution."



INSTALL () {
    dnf list installed | grep -q $1
if [ $? -eq 0 ]; then
    echo "$1 is already installed."
else
    echo "$1 is not installed. Installing..."
    dnf install -y $1 &>> $INSTALL_LOGS_FILE
    if [ $? -ne 0 ]; then
        echo "Failed to install $1."
        echo "script exit with status code 1"   exit 1
    else
        echo "$1 installed successfully."
        systemctl start $1 &>> $STATUS_LOGS_FILE
        STATUS=$(systemctl status $1)
        echo "$STATUS" | grep -q "active (running)" &>> $STATUS_LOGS_FILE
        if [ $? -eq 0 ]; then
            echo "$1 is running."
        else
            echo "$1 failed to start."
        fi
    fi
fi
}
INSTALL "$SERVER_TO_BE_INSTALLED"