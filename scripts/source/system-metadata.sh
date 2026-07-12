#!/bin/sh

# Exports following system metadata variables
#  - DISTRO - Base Linux distribution where the system is running at
#  - MANUFACTURER - Computer manufacturer name
#  - HAS_BATTERY - Set to 1 if current system has a battery, 0 otherwise

# Set DISTRO variable
ID="$(grep -E --color=none '^ID=[a-z0-9_]+$' /etc/os-release | sed -r 's/ID=([a-z0-9_]+)/\1/g')"
ID_LIKE="$(grep -E --color=none '^ID_LIKE=[a-z0-9_]+$' /etc/os-release | sed -r 's/ID_LIKE=([a-z0-9_]+)/\1/g')"

if [ -n "$ID_LIKE" ] && [ "$ID" != "ubuntu" ]; then
    export DISTRO="$ID_LIKE"
else
    export DISTRO="$ID"
fi

# Set HAS_BATTERY variable
if [ -n "$(ls /sys/class/power_supply/BAT* 2>/dev/null)" ]; then
    export HAS_BATTERY=0
else
    export HAS_BATTERY=1
fi