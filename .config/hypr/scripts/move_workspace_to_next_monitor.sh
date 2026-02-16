#!/bin/bash

# Get list of monitor names
monitors=($(hyprctl monitors -j | jq -r '.[].name'))

# Get current workspace monitor
current_monitor=$(hyprctl activeworkspace -j | jq -r '.monitor')

# Find index of current monitor
current_index=-1
for i in "${!monitors[@]}"; do
    if [[ "${monitors[$i]}" == "$current_monitor" ]]; then
        current_index=$i
        break
    fi
done

# Error handling
if [[ $current_index -eq -1 ]]; then
    echo "Current monitor not found in monitor list"
    exit 1
fi

# Determine the next monitor (wrap around)
next_index=$(( (current_index + 1) % ${#monitors[@]} ))
next_monitor="${monitors[$next_index]}"

# Move current workspace to next monitor
hyprctl dispatch movecurrentworkspacetomonitor "$next_monitor"

