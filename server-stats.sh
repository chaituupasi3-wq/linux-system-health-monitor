#!/bin/bash

# ==========================================
# Server Performance Analysis Script
# Project: https://roadmap.sh/projects/server-stats
# ==========================================

echo "=================================================="
echo "          SERVER PERFORMANCE STATS               "
echo "=================================================="
echo ""

# 1. OS Version
echo "--- OS Version ---"
if [ -f /etc/os-release ]; then
    grep -E '^PRETTY_NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '"'
else
    uname -s -r
fi
echo ""

# 2. Uptime & Load Average
echo "--- Uptime & Load Average ---"
uptime -p 2>/dev/null || uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}'
echo -n "Load Average: "
uptime | awk -F'load average:' '{ print $2 }'
echo ""

# 3. Total CPU Usage
echo "--- CPU Usage ---"
# Calculates CPU usage using top in batch mode
cpu_idle=$(top -bn1 | grep "%Cpu" | awk '{print $8}' | cut -d'.' -f1)
if [ -n "$cpu_idle" ]; then
    cpu_usage=$((100 - cpu_idle))
    echo "Total CPU Usage: ${cpu_usage}%"
else
    # Fallback using mpstat/sar or vmstat if available
    vmstat 1 2 | tail -n1 | awk '{print "Total CPU Usage: " 100-$15 "%"}'
fi
echo ""

# 4. Total Memory Usage (Free vs Used with %)
echo "--- Memory Usage ---"
free -m | awk 'NR==2{
    total=$2;
    used=$3;
    free=$4;
    usage_pct=(used/total)*100;
    free_pct=(free/total)*100;
    printf "Total: %d MB | Used: %d MB (%.2f%%) | Free: %d MB (%.2f%%)\n", total, used, usage_pct, free, free_pct
}'
echo ""

# 5. Total Disk Usage (Free vs Used with %)
echo "--- Disk Usage (Root Filesystem /) ---"
df -h / | awk 'NR==2{
    total=$2;
    used=$3;
    free=$4;
    usage_pct=$5;
    printf "Total: %s | Used: %s (%s) | Free: %s\n", total, used, usage_pct, free
}'
echo ""

# 6. Top 5 Processes by CPU Usage
echo "--- Top 5 Processes by CPU Usage ---"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 | awk '{printf "%-8s %-8s %-6s %-6s %-s\n", $1, $2, $4, $5, $3}'
echo ""

# 7. Top 5 Processes by Memory Usage
echo "--- Top 5 Processes by Memory Usage ---"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6 | awk '{printf "%-8s %-8s %-6s %-6s %-s\n", $1, $2, $4, $5, $3}'
echo ""

# 8. Logged-in Users & Failed Login Attempts (Stretch Goals)
echo "--- User Activity & Security ---"
echo "Logged-in Users:"
who | awk '{print " - " $1 " (Terminal: " $2 ", Logged in: " $3 " " $4 ")"}' || echo " No active users found"

echo ""
echo "Failed Login Attempts:"
if [ -f /var/log/auth.log ]; then
    failed_count=$(grep -c "Failed password" /var/log/auth.log 2>/dev/null)
    echo " Total Failed Logins: ${failed_count:-0}"
elif [ -f /var/log/secure ]; then
    failed_count=$(grep -c "Failed password" /var/log/secure 2>/dev/null)
    echo " Total Failed Logins: ${failed_count:-0}"
else
    echo " Auth log not directly accessible or log file not found."
fi

echo ""
echo "=================================================="