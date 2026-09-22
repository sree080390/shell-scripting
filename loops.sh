#!/bin/bash

USER_ID=$(id -u)
INSTALL_LOGS_FILE="/var/log/shell-script.log"
STATUS_LOGS_FILE="/var/log/shell-script-status.log"
$TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
read -p "Enter the server to be installed (e.g., httpd, nginx): " SERVER_TO_BE_INSTALLED
if [ $USER_ID -ne 0 ]; then
    echo "Script execution started at $TIMESTAMP" | tee -a $STATUS_LOGS_FILE
    echo "$TIMESTAMP [ERROR] You are not root user. Please run the script as root." | tee -a $STATUS_LOGS_FILE
    exit 1
fi
echo "$TIMESTAMP [INFO] You are root user. Proceeding with the script execution."

for packages in $@ {
do
STATUS_VALIDATE () {
    systemctl start $1 | tee -a $STATUS_LOGS_FILE
    STATUS=$(systemctl status $1)
    echo "$TIMESTAMP [INFO] $STATUS" | grep -q "active (running)" | tee -a $STATUS_LOGS_FILE
    if [ $? -eq 0 ]; then
        echo "$TIMESTAMP [INFO] $1 is running." | tee -a $STATUS_LOGS_FILE
    else
        echo "$TIMESTAMP [ERROR] $1 failed to start." | tee -a $STATUS_LOGS_FILE
    fi
}

INSTALL () {
    dnf list installed | grep -q $1
if [ $? -eq 0 ]; then
    echo "$1 is already installed." | tee -a $INSTALL_LOGS_FILE
else
    echo "$TIMESTAMP [ERROR] $1 is not installed. Installing..."
    dnf install -y $1 &>> $INSTALL_LOGS_FILE
    if [ $? -ne 0 ]; then
        echo "$TIMESTAMP [ERROR] Failed to install $1." | tee -a $INSTALL_LOGS_FILE
        echo "$TIMESTAMP [ERROR] script exit with status code 1" | tee -a $INSTALL_LOGS_FILE
        exit 1
    else
        echo "$TIMESTAMP [INFO] $1 installed successfully." | tee -a $INSTALL_LOGS_FILE
        if [ $1 == "mysql-server" ];then
            STATUS_VALIDATE mysqld
        else
            STATUS_VALIDATE $1
        fi
    fi
fi
}
INSTALL ($@)
done    
}

