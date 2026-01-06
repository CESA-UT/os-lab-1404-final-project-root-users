#!/bin/bash

# --- تنظیمات و رنگ‌ها ---
CONFIG_FILE="/etc/root-monitor.conf"
[ -f "$CONFIG_FILE" ] && . "$CONFIG_FILE"

SORT_TYPE=${SORT_BY:-"cpu"}
RED='\e[1;31m'
YELLOW='\e[1;33m'
GREEN='\e[1;32m'
WHITE='\e[1;37m'
BLUE='\e[1;34m'
CYAN='\e[1;36m'
RESET='\e[0m'

# --- توابع کمکی ---
print_usage() {
    echo -e "${BLUE}Root-Monitor v1.0 - OS Lab Project${RESET}"
    echo -e "Usage: root-monitor [OPTIONS]"
    echo -e "\nOptions:"
    printf "  ${CYAN}%-15s${RESET} %s\n" "-l, --list" "Show top 10 processes with status colors"
    printf "  ${CYAN}%-15s${RESET} %s\n" "-s, --search" "Find process by name (formatted output)"
    printf "  ${CYAN}%-15s${RESET} %s\n" "-k, --kill" "Terminate a process with confirmation"
    printf "  ${CYAN}%-15s${RESET} %s\n" "-h, --help" "Show this interactive menu"
}

# --- مدیریت آرگومان‌ها ---
case "$1" in
    -l|--list)
        echo -e "${BLUE}🔍 Monitoring System (Sorted by $SORT_TYPE)...${RESET}"
        printf "${WHITE}%-8s %-8s %-25s %-8s %-8s %-10s${RESET}\n" "PID" "PPID" "COMMAND" "%CPU" "%MEM" "STATUS"
        echo "----------------------------------------------------------------------"

        if [ "$SORT_TYPE" == "mem" ]; then
            DATA=$(ps -eo pid,ppid,comm,%mem,%cpu --sort=-%mem | sed 1d | head -n 10)
        else
            DATA=$(ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | sed 1d | head -n 10)
        fi

        echo "$DATA" | while read pid ppid comm v1 v2; do
            # تبدیل به عدد صحیح برای مقایسه
            usage=$(printf "%.0f" "$v1")
            
            if [ "$usage" -ge 70 ]; then
                COLOR=$RED; STATUS="[CRITICAL]"
            elif [ "$usage" -ge 15 ]; then
                COLOR=$YELLOW; STATUS="[WARNING]"
            else
                COLOR=$GREEN; STATUS="[NORMAL]"
            fi
            
            printf "${COLOR}%-8s %-8s %-25.25s %-8s %-8s %-10s${RESET}\n" "$pid" "$ppid" "$comm" "$v1" "$v2" "$STATUS"
        done
        ;;

    -s|--search)
        if [ -z "$2" ]; then
            echo -e "${RED}❌ Error: Please provide a process name to search.${RESET}"
            exit 1
        fi
        echo -e "${BLUE}🔎 Searching for processes matching: ${CYAN}$2${RESET}"
        printf "${WHITE}%-8s %-8s %-15s %-30s${RESET}\n" "PID" "PPID" "USER" "COMMAND"
        echo "----------------------------------------------------------------------"
        
        ps -eo pid,ppid,user,comm | grep -i "$2" | grep -v "grep" | grep -v "root-monitor" | while read pid ppid user comm; do
            printf "${CYAN}%-8s${RESET} %-8s %-15s ${WHITE}%-30.30s${RESET}\n" "$pid" "$ppid" "$user" "$comm"
        done
        ;;

    -k|--kill)
        if [ -z "$2" ]; then
            echo -e "${RED}❌ Error: Missing PID.${RESET}"
            exit 1
        fi
        # تاییدیه برای امنیت بیشتر
        read -p "⚠️ Are you sure you want to kill process $2? (y/n): " confirm
        if [[ $confirm == [yY] ]]; then
            kill -15 "$2" 2>/dev/null && echo -e "${GREEN}✅ SIGTERM sent to $2 successfully.${RESET}" || echo -e "${RED}❌ Error: Process $2 not found or access denied.${RESET}"
        else
            echo -e "${YELLOW}Operation cancelled.${RESET}"
        fi
        ;;

    -h|--help)
        print_usage
        ;;

    *)
        print_usage
        exit 1
        ;;
esac