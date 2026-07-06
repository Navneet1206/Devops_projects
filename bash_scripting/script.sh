#!/bin/bash

# Rang-biranga look dene ke liye variables
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Functions for Operations
show_cpu() {
    echo -e "${CYAN}=== CPU Information ===${NC}"
    lscpu | grep -E "Model name:|CPU\(s\):|Core\(s\) per socket:"
    echo -n "Current Usage: "
    grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.2f%%\n", usage}'
}

show_mem() {
    echo -e "${GREEN}=== Memory Information ===${NC}"
    free -h
}

show_disk() {
    echo -e "${YELLOW}=== Disk Information ===${NC}"
    df -h --total | grep -E "Filesystem|total"
}

show_sys() {
    echo -e "${CYAN}=== System Information ===${NC}"
    echo -e "OS: $(hostnamectl | grep "Operating System" | cut -d: -f2 | xargs)"
    echo -e "Kernel: $(uname -r)"
    echo -e "Architecture: $(uname -m)"
}

show_net() {
    echo -e "${GREEN}=== Network Information ===${NC}"
    echo -e "Hostname: $(hostname)"
    echo -e "IP Address: $(hostname -I | awk '{print $1}')"
}

show_all() {
    clear
    echo -e "${YELLOW}=======================================================${NC}"
    echo -e "${YELLOW}||             FULL SYSTEM HEALTH DASHBOARD          ||${NC}"
    echo -e "${YELLOW}=======================================================${NC}"
    show_sys; echo ""
    show_cpu; echo ""
    show_mem; echo ""
    show_disk; echo ""
    show_net; echo ""
    echo -e "${YELLOW}=======================================================${NC}"
}

# Loop start hota hai yahan se
while true; do
    echo -e "\n${CYAN}=======================================================${NC}"
    echo -e "${CYAN}||        AVNEET'S ULTIMATE LINUX TOOLKIT            ||${NC}"
    echo -e "${CYAN}=======================================================${NC}"
    
    # 40 Options ka Menu Matrix Form mein (taki screen par bheege nahi)
    echo -e "1) CPU Info\t\t\t11) System Uptime\t\t21) Disk Usage Analyzer\t\t31) DNS Resolution Test"
    echo -e "2) Memory Info\t\t\t12) Load Average\t\t22) Largest Files\t\t32) Process Search"
    echo -e "3) Disk Info\t\t\t13) Mounted File Systems\t23) Largest Directories\t\t33) Kill Process"
    echo -e "4) System Info\t\t\t14) Open Ports\t\t\t24) Zombie Processes\t\t34) Compress Directory"
    echo -e "5) Network Info\t\t\t15) Active Net Connections\t25) Environment Variables\t35) Backup Directory"
    echo -e "6) Running Processes\t\t16) Running Services\t\t26) Scheduled Cron Jobs\t\t36) Generate Health Report"
    echo -e "7) Top CPU Processes\t\t17) Failed Services\t\t27) Installed Packages\t\t37) System Update Check"
    echo -e "8) Top Memory Processes\t\t18) SSH Login History\t\t28) Kernel Information\t\t38) Clear Cache"
    echo -e "9) Logged In Users\t\t19) Failed Login Attempts\t29) Firewall Status\t\t39) Log File Analyzer"
    echo -e "10) User Information\t\t20) Recent System Errors\t30) Internet Connect Test\t40) Exit (or press 'q')"
    echo -e "${YELLOW}Type 'all' to view full dashboard at once.${NC}"
    echo -e "${CYAN}=======================================================${NC}"

    read -p "Enter Choice (1-40 / all / q): " ops

    # Check for 'q' or 'Q' to exit early
    if [[ "$ops" == "q" || "$ops" == "Q" || "$ops" == "40" ]]; then
        echo -e "${GREEN}Exiting... Bbye bhai!${NC}"
        break
    fi

    echo -e "\n--- Output Start ---"

    case $ops in
        all) show_all ;;
        1) show_cpu ;;
        2) show_mem ;;
        3) show_disk ;;
        4) show_sys ;;
        5) show_net ;;
        6) echo "=== Running Processes ==="; ps aux | wc -l | awk '{print "Total Running Processes: " $1}' ;;
        7) echo "=== Top 5 CPU Consuming Processes ==="; ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6 ;;
        8) echo "=== Top 5 Memory Consuming Processes ==="; ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6 ;;
        9) echo "=== Currently Logged In Users ==="; who ;;
        10) echo "=== User Information ==="; id ;;
        11) echo "=== System Uptime ==="; uptime -p ;;
        12) echo "=== Load Average ==="; cat /proc/loadavg ;;
        13) echo "=== Mounted File Systems ==="; mount | column -t | head -n 20 ;;
        14) echo "=== Open Ports ==="; ss -tulpn ;;
        15) echo "=== Active Network Connections ==="; ss -s ;;
        16) echo "=== Running Services ==="; systemctl list-units --type=service --state=running | head -n 20 ;;
        17) echo "=== Failed Services ==="; systemctl --failed ;;
        18) echo "=== SSH Login History ==="; last -a -i | head -n 15 ;;
        19) echo "=== Failed Login Attempts ==="; grep "Failed password" /var/log/auth.log 2>/dev/null | tail -n 10 || echo "Logs not accessible (Run as sudo)" ;;
        20) echo "=== Recent System Errors ==="; journalctl -p 3 -xb -n 10 --no-pager ;;
        21) echo "=== Disk Usage Analyzer (Top Partitions) ==="; df -h ;;
        22) echo "=== 5 Largest Files in Current Dir ==="; find . -type f -exec du -h {} + 2>/dev/null | sort -rh | head -n 5 ;;
        23) echo "=== 5 Largest Directories in Current Dir ==="; du -h --max-depth=1 2>/dev/null | sort -rh | head -n 5 ;;
        24) echo "=== Zombie Processes ==="; ps aux | awk '"[Zz]" ~ $8 {print}' || echo "No zombie processes found." ;;
        25) echo "=== Environment Variables (Top 15) ==="; env | head -n 15 ;;
        26) echo "=== Scheduled Cron Jobs (Current User) ==="; crontab -l || echo "No crontab for current user." ;;
        27) echo "=== Number of Installed Packages ==="; dpkg -l | wc -l | awk '{print "Total: " $1 " packages installed."}' ;;
        28) echo "=== Kernel Information ==="; uname -a ;;
        29) echo "=== Firewall Status ==="; sudo ufw status 2>/dev/null || echo "Run as sudo to check firewall status" ;;
        30) echo "=== Internet Connectivity Test ==="; ping -c 3 8.8.8.8 && echo "Internet Working!" || echo "Internet Down!" ;;
        31) echo "=== DNS Resolution Test ==="; nslookup google.com | tail -n 4 ;;
        32) 
            read -p "Enter process name to search: " p_name
            ps aux | grep -i "$p_name" | grep -v grep
            ;;
        33) 
            read -p "Enter PID to kill: " pid_kill
            kill -9 $pid_kill && echo "Process $pid_kill killed successfully." || echo "Failed to kill process."
            ;;
        34) 
            read -p "Enter Directory path to compress: " dir_comp
            tar -czf "${dir_comp##*/}.tar.gz" "$dir_comp" && echo "Compressed as ${dir_comp##*/}.tar.gz"
            ;;
        35) 
            read -p "Enter source directory path: " src_dir
            mkdir -p ~/backups
            tar -czf ~/backups/backup_$(date +%F_%H%M%S).tar.gz "$src_dir" && echo "Backup saved to ~/backups/"
            ;;
        36) 
            report_file="health_report_$(date +%F).txt"
            show_all > "$report_file"
            echo -e "${GREEN}System Health Report generated successfully: $report_file${NC}"
            ;;
        37) echo "=== Checking for System Updates ==="; apt list --upgradable 2>/dev/null | head -n 20 ;;
        38) echo "=== Clearing PageCache (Needs Sudo) ==="; sudo sync; echo 1 | sudo tee /proc/sys/vm/drop_caches > /dev/null && echo "Cache cleared!" ;;
        39) echo "=== Analyzing System Logs (Last 15 lines) ==="; tail -n 15 /var/log/syslog 2>/dev/null || tail -n 15 /var/log/messages 2>/dev/null || echo "Cannot access logs." ;;
        *) echo -e "${RED}Invalid Option! Sahi operation chuno bhai.${NC}" ;;
    esac

    echo -e "--- Output End ---"
    read -p "Press [Enter] to continue..." temp
    clear
done
