#!/bin/bash

# Rang-biranga look dene ke liye variables (Optional par accha lagta hai)
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. CPU Info Function
cpu_info(){
    echo -e "${CYAN}=======================================================${NC}"
    echo -e "${CYAN}||                CPU INFORMATION                    ||${NC}"
    echo -e "${CYAN}=======================================================${NC}"
    echo ""
    echo -e "${YELLOW}>>> MODEL NAME:${NC}"
    lscpu | grep "Model name:" | sed 's/Model name://' | xargs
    echo ""
    echo -e "${YELLOW}>>> NUMBER OF CORES & THREADS:${NC}"
    lscpu | grep -E "CPU\(s\):|Core\(s\) per socket:|Thread\(s\) per core:"
    echo ""
    echo -e "${YELLOW}>>> CURRENT CPU USAGE:${NC}"
    grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.2f%%\n", usage}'
}

# 2. Memory Info Function
mem_info(){
    echo -e "${GREEN}=======================================================${NC}"
    echo -e "${GREEN}||               MEMORY INFORMATION                  ||${NC}"
    echo -e "${GREEN}=======================================================${NC}"
    echo ""
    free -h
}

# 3. Disk Space Function
disk_info(){
    echo -e "${YELLOW}=======================================================${NC}"
    echo -e "${YELLOW}||                DISK SPACE USAGE                   ||${NC}"
    echo -e "${YELLOW}=======================================================${NC}"
    echo ""
    df -h --total | grep -E "Filesystem|total"
}

# 4. System OS Info Function
sys_info(){
    echo -e "${CYAN}=======================================================${NC}"
    echo -e "${CYAN}||               SYSTEM & OS DETAILS                 ||${NC}"
    echo -e "${CYAN}=======================================================${NC}"
    echo ""
    echo -e "${YELLOW}OS Version:${NC} $(hostnamectl | grep "Operating System" | cut -d: -f2 | xargs)"
    echo -e "${YELLOW}Kernel Version:${NC} $(uname -r)"
    echo -e "${YELLOW}System Uptime:${NC} $(uptime -p)"
}

# 5. Network Info Function
net_info(){
    echo -e "${GREEN}=======================================================${NC}"
    echo -e "${GREEN}||               NETWORK INFORMATION                 ||${NC}"
    echo -e "${GREEN}=======================================================${NC}"
    echo ""
    echo -e "${YELLOW}Hostname:${NC} $(hostname)"
    echo -e "${YELLOW}Local IP Address:${NC} $(hostname -I | awk '{print $1}')"
}

# Main Menu Display
echo -e "${YELLOW}Avneet's Linux System Monitor Tool${NC}"
echo "-----------------------------------"
echo "1) View CPU Information"
echo "2) View Memory (RAM) Usage"
echo "3) View Disk Space Status"
echo "4) View System & OS Details"
echo "5) View Network Details"
echo "6) Exit"
echo "-----------------------------------"

read -p "Enter your choice [1-6]: " ops
echo ""

case $ops in
    1)
        cpu_info
        ;;
    2)
        mem_info
        ;;
    3)
        disk_info
        ;;
    4)
        sys_info
        ;;
    5)
        net_info
        ;;
    6)
        echo "Exiting... Have a great day!"
        exit 0
        ;;
    *)
        echo -e "\033[0;31mInvalid option! Please run the script again and choose between 1-6.\033[0m"
        ;;
esac
echo ""
