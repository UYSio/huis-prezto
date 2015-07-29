#!/usr/bin/env bash
# Prezto wrapper which basically runs the commands over at
# https://github.com/sorin-ionescu/prezto#readme and
# points to extra ~/.z* things

# run the platform-specific prereq:
SCRIPT=$(uname)
echo "Running platform-specific script: $SCRIPT"
./$SCRIPT

echo "Running prezto"
./prezto.sh
