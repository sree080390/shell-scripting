#!/bin/bash

echo "All the values passed to script are: $@"
echo "The number of values passed to script are: $#"
echo "First value passed to script is: $1"
echo "What is the name of the script: $0"
echo "Who is the current user: $USER"
echo "In which directory the script is running: $PWD"
echo "What is current user's home directory: $HOME"
echo "What is the current process id: $$"
sleep 5
echo "What is the last process id: $!"