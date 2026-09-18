#!/bin/bash
MEMBERS=("Alice" "Bob" "Charlie" "David" "Eve")
echo "All members: ${MEMBERS[@]}"
echo "Number of members: ${#MEMBERS[@]}"    
echo "First member: ${MEMBERS[0]}"
echo "Last member: ${MEMBERS[-1]}"
echo "All members in reverse order: ${MEMBERS[@]::0}"