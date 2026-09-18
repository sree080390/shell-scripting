#!/bin/bash

read -p "Enter a number: " num
if [ $num -gt 10 ]; then
    echo "The number is greater than 10."
elif [ $num -eq 10 ]; then
    echo "The number is equal to 10."
    exit 1 # If this condition is true, the script will exit with a status of 1
else
    echo "The number is less than 10."
fi