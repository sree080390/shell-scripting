#!/bin/bash

USER_ID=$(id -u)
INSTALL_LOGS_FILE="/var/log/shell-script.log"
STATUS_LOGS_FILE="/var/log/shell-script-status.log"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
R="\e[31m]"
Y="\e[33m]"
G="\e[32m]"
N="\e[0m]"
#read -p "Enter the server to be installed (e.g., httpd, nginx): " SERVER_TO_BE_INSTALLED
if [ $USER_ID -ne 0 ]; then
    echo "Script execution started at $TIMESTAMP" | tee -a $STATUS_LOGS_FILE
    echo -e "$TIMESTAMP [ERROR] You are $R not root user $N. Please run the script as root." | tee -a $STATUS_LOGS_FILE
    exit 1
fi
echo -e "$TIMESTAMP [INFO] You are $G root user $N. Proceeding with the script execution."


STATUS_VALIDATE () {
    systemctl start $1 | tee -a $STATUS_LOGS_FILE
    STATUS=$(systemctl status $1)
    echo "$TIMESTAMP [INFO] $STATUS" | grep -q "active (running)" | tee -a $STATUS_LOGS_FILE
    if [ $? -eq 0 ]; then
        echo "$TIMESTAMP [INFO] $1 is running." | tee -a $STATUS_LOGS_FILE
    else
        echo -e "$TIMESTAMP [ERROR] $1 $R failed to start.$N" | tee -a $STATUS_LOGS_FILE
    fi
}

INSTALL () {
    dnf list installed | grep -q $1
if [ $? -eq 0 ]; then
    echo -e "$TIMESTAMP [INFO] $1 is $Y already installed. $N" | tee -a $INSTALL_LOGS_FILE
else
    echo -e "$TIMESTAMP [ERROR] $1 is not $R installed. $N Installing..." | tee -a $INSTALL_LOGS_FILE
    dnf install -y $1 &>> $INSTALL_LOGS_FILE
    if [ $? -ne 0 ]; then
        echo -e "$TIMESTAMP [ERROR] $1 $R failed to install.$N" | tee -a $INSTALL_LOGS_FILE
        echo -e "$TIMESTAMP [ERROR] script exit with status code 1" | tee -a $INSTALL_LOGS_FILE
        exit 1
    else
        echo -e "$TIMESTAMP [INFO] $1 $G installed successfully.$N" | tee -a $INSTALL_LOGS_FILE
        if [ $1 == "mysql-server" ];then
            STATUS_VALIDATE mysqld
        else
            STATUS_VALIDATE $1
        fi
    fi
fi
}

for packages in $@
do
    INSTALL "$packages"
done

