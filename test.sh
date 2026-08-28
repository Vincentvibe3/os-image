#!/usr/bin/bash
shopt -s nullglob
set -euo pipefail

FILE="example.txt"
files=(./files/scripts/*.sh)
if [[ -v files ]]; then
    echo "$FILE exists."
else
    echo "$FILE does not exist."
fi
shopt -u nullglob

if [ -f "./files/scripts" ]; then
    echo "File exists."
else
    echo "File does not exist."
fi