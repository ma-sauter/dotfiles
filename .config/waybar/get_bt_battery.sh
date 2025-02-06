#!/bin/bash

DEVICE_MAC=$(pactl list sinks | awk -F'[ .]' '/Name: bluez_sink/ {gsub("_", ":", $3); print $3}')

BATTERY_LEVEL=$(bluetoothctl info $DEVICE_MAC | grep "Battery Percentage" | awk '{print $4}' | tr -d '()')

if [[ -z "$BATTERY_LEVEL" ]]; then
    echo '{"text": "", "tooltip": "Bluetooth Battery status unavailable"}'
else
    echo "{\"text\": \"🎧 $BATTERY_LEVEL%\", \"tooltip\": \"Bluetooth Battery: $BATTERY_LEVEL%\"}"
fi
