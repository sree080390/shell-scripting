#!/bin/bash

read -p "Enter a number: " num
if [ $num -gt 10 ]; then
    echo "The number is greater than 10."
elif [ $num -eq 10 ]; then
    exit 1 
    echo "The number is equal to 10."
    
else
    echo "The number is less than 10."
fi


USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
    echo "You are not root user. Please run the script as root."
    exit 1
fi
echo "You are root user. Proceeding with the script execution."
dnf install -y httpd
