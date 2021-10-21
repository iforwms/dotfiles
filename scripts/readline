#!/bin/bash

Counter=0

function process_line() {
    echo "Processing line $Counter: $1"
}

while IFS='' read -r LineFromFile || [[ -n "${LineFromFile}" ]]; do
    ((Counter++))
    process_line "$LineFromFile"
done < "$1"
