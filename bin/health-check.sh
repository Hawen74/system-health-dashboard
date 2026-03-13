#!/bin/bash
#
# health-check.sh - System Health Dashboard
#
# DESCRIPTION:
#   Displays a color-coded system health report including CPU usage,
#   memory usage, disk usage, uptime, and current logged-in users.
#   Designed as a quick "at-a-glance" diagnostic tool for any Linux system.
#
# USAGE:
#   health-check.sh [-h] [-d]
#
# OPTIONS:
#   -h    Show help and exit
#   -d    Enable debug mode
#
# AUTHOR: [Your Name] & Claude (Anthropic AI)
# VERSION: 1.0.0
# DATE: 2026-03-13
#
# ----------------------------------------------------------------------

# 1. Environment & Library Setup
source "$REPO_ROOT/lib/tools.sh"

# ----------------------------------------------------------------------
# CONSTANTS - Color codes for terminal output
# ----------------------------------------------------------------------
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'
CYAN='\e[36m'
BOLD='\e[1m'
RESET='\e[0m'

#######################################
# Displays script usage information and exits.
#######################################
usage() {
    cat <<EOF
USAGE: $(basename "$0") [OPTIONS]

DESCRIPTION:
    Displays a color-coded system health report.
    Checks CPU, memory, disk, uptime, and logged-in users.

OPTIONS:
    -h, --help      Display this help message and exit.
    -d, --debug     Enable debug mode (show log messages).

EXAMPLES:
    health-check.sh
    health-check.sh -d
EOF
    exit 0
}

#######################################
# Prints a section header to stdout.
# Arguments:
#   $1 - The title text for the section.
#######################################
print_header() {
    echo -e "\n${BOLD}${CYAN}══════════════════════════════════════${RESET}"
    echo -e "${BOLD}${CYAN}  $1${RESET}"
    echo -e "${BOLD}${CYAN}══════════════════════════════════════${RESET}"
}

#######################################
# Prints a status line with color coding based on usage level.
# Green = OK (< 70%), Yellow = Warning (70-89%), Red = Critical (>= 90%)
# Arguments:
#   $1 - Label (e.g. "CPU Usage")
#   $2 - Usage percentage as an integer (e.g. 45)
#   $3 - Display string (e.g. "45%")
#######################################
print_status() {
    local label="$1"
    local usage_int="$2"
    local display="$3"
    local color

    if [ "$usage_int" -ge 90 ]; then
        color="$RED"
    elif [ "$usage_int" -ge 70 ]; then
        color="$YELLOW"
    else
        color="$GREEN"
    fi

    printf "  %-20s ${color}%s${RESET}\n" "$label:" "$display"
}

# ----------------------------------------------------------------------
# 2. Flag Parsing
# ----------------------------------------------------------------------
while getopts "hd" opt; do
    case ${opt} in
        h ) usage ;;
        d ) export DEBUG=1 ;;
        \? ) echo "Invalid option. Use -h for help." >&2; exit 1 ;;
    esac
done

# ----------------------------------------------------------------------
# 3. Dependency Check
# ----------------------------------------------------------------------
for cmd in top free df uptime who; do
    if ! command -v "$cmd" &> /dev/null; then
        echo -e "${RED}ERROR:${RESET} Required command '$cmd' not found." >&2
        exit 1
    fi
done
log "All dependencies verified."

# ----------------------------------------------------------------------
# 4. Data Collection
# ----------------------------------------------------------------------

# -- CPU Usage --
# Uses /proc/stat to calculate CPU idle percentage, then subtracts from 100
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
CPU_USED=$((100 - CPU_IDLE))
log "CPU used: $CPU_USED%"

# -- Memory Usage --
MEM_TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/^Mem:/ {print $3}')
MEM_PCT=0
if [ "$MEM_TOTAL" -gt 0 ]; then
    MEM_PCT=$(( (MEM_USED * 100) / MEM_TOTAL ))
fi
log "Memory: ${MEM_USED}MB used of ${MEM_TOTAL}MB (${MEM_PCT}%)"

# -- Disk Usage (root partition) --
DISK_PCT=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
log "Disk: ${DISK_USED} used of ${DISK_TOTAL} (${DISK_PCT}%)"

# -- Uptime --
UPTIME_STR=$(uptime -p 2>/dev/null || uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}')
log "Uptime: $UPTIME_STR"

# -- Logged In Users --
USER_COUNT=$(who | wc -l)
USER_LIST=$(who | awk '{print $1}' | sort -u | tr '\n' ' ')
log "Users logged in: $USER_COUNT"

# -- Load Average --
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | xargs)
log "Load average: $LOAD_AVG"

# -- Hostname & IP --
HOST_NAME=$(hostname)
HOST_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
log "Host: $HOST_NAME / IP: $HOST_IP"

# ----------------------------------------------------------------------
# 5. Output Phase — Print the Dashboard
# ----------------------------------------------------------------------
clear

echo -e "${BOLD}${CYAN}"
echo "  ╔═══════════════════════════════════════╗"
echo "  ║     🖥️  SYSTEM HEALTH DASHBOARD        ║"
echo "  ╚═══════════════════════════════════════╝"
echo -e "${RESET}"

echo -e "  ${BOLD}Host:${RESET}  $HOST_NAME"
echo -e "  ${BOLD}IP:${RESET}    ${HOST_IP:-N/A}"
echo -e "  ${BOLD}Date:${RESET}  $(date '+%A, %B %d %Y  %H:%M:%S')"

print_header "⚡ Performance"
print_status "CPU Usage"    "$CPU_USED"  "${CPU_USED}%"
print_status "Memory Usage" "$MEM_PCT"   "${MEM_USED}MB / ${MEM_TOTAL}MB (${MEM_PCT}%)"
print_status "Disk Usage"   "$DISK_PCT"  "${DISK_USED} / ${DISK_TOTAL} (${DISK_PCT}%)"

print_header "🕒 System Info"
echo -e "  $(printf '%-20s' 'Uptime:') ${GREEN}${UPTIME_STR}${RESET}"
echo -e "  $(printf '%-20s' 'Load Average:')  ${LOAD_AVG}"

print_header "👥 Active Users"
if [ "$USER_COUNT" -eq 0 ]; then
    echo -e "  ${YELLOW}No users currently logged in.${RESET}"
else
    echo -e "  ${GREEN}${USER_COUNT} user(s):${RESET} $USER_LIST"
fi

echo -e "\n${CYAN}══════════════════════════════════════${RESET}"
echo -e "  ${BOLD}Color Key:${RESET}  ${GREEN}● OK${RESET}  ${YELLOW}● Warning (70%+)${RESET}  ${RED}● Critical (90%+)${RESET}"
echo -e "${CYAN}══════════════════════════════════════${RESET}\n"

log "Health check complete."