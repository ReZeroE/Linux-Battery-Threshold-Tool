#!/bin/bash

show_help() {
    echo "Usage: sudo ./set_battery_threshold.sh [options]"
    echo
    echo "Options:"
    echo "  -h, --help          Display this help message and exit"
    echo "  --show              Show the current battery threshold for all detected batteries"
    echo
    echo "Description:"
    echo "This script allows you to set or view the battery charge control end threshold for"
    echo "laptops that support battery threshold management."
    echo
    echo "Instructions:"
    echo "  1. Run the script with superuser privileges."
    echo "  2. If multiple batteries are detected, you will be prompted to select one."
    echo "  3. Enter a threshold value between 60 and 100."
    echo
    echo "Examples:"
    echo "  sudo ./set_battery_threshold.sh          # Set the threshold for a battery"
    echo "  sudo ./set_battery_threshold.sh --show   # Show the current thresholds"
    exit 0
}
show_thresholds() {
    echo "Current battery charge control end thresholds:"
    for battery_path in /sys/class/power_supply/BAT*/charge_control_end_threshold; do
        if [[ -f "$battery_path" ]]; then
            battery_name=$(basename "$(dirname "$battery_path")")
            threshold=$(cat "$battery_path")
            echo "$battery_name: $threshold%"
        fi
    done
    exit 0
}


if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
fi
if [[ "$1" == "--show" ]]; then
    show_thresholds
fi

# Force root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

# Search for battery directories
battery_paths=(/sys/class/power_supply/BAT*/charge_control_end_threshold)
battery_count=${#battery_paths[@]}

# Check if battery threshold control file exist
if [ "$battery_count" -eq 0 ]; then
    echo "No batteries with a 'charge_control_end_threshold' file found."
    exit 1
fi

# Display available batteries and prompt user to select one if multiple are found
if [ "$battery_count" -gt 1 ]; then
    echo "Multiple batteries detected:"
    for i in "${!battery_paths[@]}"; do
        echo "$i) ${battery_paths[$i]}"
    done
    read -p "Enter the number of the battery you want to set the threshold for: " battery_choice
    if ! [[ "$battery_choice" =~ ^[0-9]+$ ]] || [ "$battery_choice" -ge "$battery_count" ]; then
        echo "Invalid choice. Exiting."
        exit 1
    fi
    battery_path="${battery_paths[$battery_choice]}"
else
    battery_path="${battery_paths[0]}"
fi


read -p "Enter battery threshold (60-100): " threshold
if ! [[ "$threshold" =~ ^[0-9]+$ ]] || [ "$threshold" -lt 60 ] || [ "$threshold" -gt 100 ]; then
    echo "Invalid input. The threshold must be an integer between 60 and 100."
    exit 1
fi

# Set the threshold and verify
echo $threshold > "$battery_path"
if [ $? -eq 0 ]; then
    echo "Battery threshold set to $threshold% successfully for $(basename $(dirname "$battery_path"))."
else
    echo "Failed to set battery threshold."
fi
