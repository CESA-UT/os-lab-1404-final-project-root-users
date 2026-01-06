#!/bin/bash

# Import system settings
CONFIG_FILE="/etc/root-monitor.conf"
if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
fi

# Set defaults if not provided by config
SORT_TYPE=${SORT_BY:-"cpu"}

# Function to print usage instructions
print_usage() {
    echo "Usage: root-monitor [OPTIONS]"
    echo "Process management tool for OS Lab"
    echo ""
    echo "Options:"
    echo "  -l, --list       Show top processes by $SORT_TYPE"
    echo "  -s, --search     Find process by name"
    echo "  -k, --kill       End process by PID"
    echo "  -h, --help       Show this menu"
}

# Handle command line arguments
case "$1" in
    -l|--list)
        echo "Displaying top processes sorted by $SORT_TYPE:"
        if [ "$SORT_TYPE" == "mem" ]; then
            ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 11
        else
            ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head -n 11
        fi
        ;;
    -s|--search)
        if [ -z "$2" ]; then
            echo "Error: Missing process name"
            exit 1
        fi
        ps -ef | grep -i "$2" | grep -v grep
        ;;
    -k|--kill)
        if [ -z "$2" ]; then
            echo "Error: Missing PID"
            exit 1
        fi
        kill -15 "$2" && echo "SIGTERM sent to $2" || echo "Error: Could not kill $2"
        ;;
    -h|--help)
        print_usage
        ;;
    *)
        print_usage
        exit 1
        ;;
esac