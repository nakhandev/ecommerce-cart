#!/bin/bash

# 🛒 E-commerce Cart System - Enhanced Status Check Script
# Version: 2.0.0
# Description: Comprehensive status monitoring for the running application

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PID_FILE="application.pid"
LOG_FILE="application.log"
PORT=8080
HEALTH_CHECK_URL="http://localhost:$PORT/actuator/health"
API_CHECK_URL="http://localhost:$PORT/api/products"

echo -e "${BLUE}📊 E-commerce Cart System Status v2.0${NC}"
echo "======================================"
echo -e "${CYAN}📊 Enhanced Monitoring & Diagnostics${NC}"
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if port is in use
check_port() {
    if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; then
        return 0  # Port is in use
    else
        return 1  # Port is free
    fi
}

# Function to get process information
get_process_info() {
    local pid=$1
    if ps -p "$pid" > /dev/null 2>&1; then
        local info=$(ps -p "$pid" -o pid,ppid,pcpu,pmem,etime,command --no-headers)
        echo "$info"
    fi
}

# Function to test application responsiveness
test_responsiveness() {
    local url=$1
    local description=$2

    echo -n "   Testing $description... "

    start_time=$(date +%s%N)
    if curl -s -f "$url" >/dev/null 2>&1; then
        end_time=$(date +%s%N)
        response_time=$((($end_time - $start_time) / 1000000))
        echo -e "${GREEN}✅ $response_time""ms${NC}"
        return 0
    else
        echo -e "${RED}❌ Failed${NC}"
        return 1
    fi
}

# Function to get system resource usage
get_system_resources() {
    echo -e "${BLUE}🔍 System Resource Usage:${NC}"

    # Memory usage
    if command_exists free; then
        FREE_MEM=$(free -h | awk 'NR==2{print $7}')
        USED_MEM=$(free -h | awk 'NR==2{print $3}')
        TOTAL_MEM=$(free -h | awk 'NR==2{print $2}')
        echo "   Memory: $USED_MEM / $TOTAL_MEM (Free: $FREE_MEM)"
    fi

    # CPU load
    if command_exists uptime; then
        LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | xargs)
        echo "   CPU Load: $LOAD_AVG"
    fi

    # Disk usage
    if command_exists df; then
        DISK_USAGE=$(df . | awk 'NR==2{print $5}')
        echo "   Disk Usage: $DISK_USAGE"
    fi

    echo ""
}

# Function to analyze log file
analyze_logs() {
    if [ -f "$LOG_FILE" ]; then
        echo -e "${BLUE}📜 Log Analysis:${NC}"

        # Get file size
        LOG_SIZE=$(du -h "$LOG_FILE" | cut -f1)
        echo "   Log Size: $LOG_SIZE"

        # Count error entries
        if command_exists grep; then
            ERROR_COUNT=$(grep -c "ERROR" "$LOG_FILE" 2>/dev/null || echo "0")
            WARN_COUNT=$(grep -c "WARN" "$LOG_FILE" 2>/dev/null || echo "0")
            echo "   Errors: $ERROR_COUNT"
            echo "   Warnings: $WARN_COUNT"
        fi

        # Show recent entries
        echo ""
        echo -e "${BLUE}📝 Recent Log Entries:${NC}"
        tail -n 3 "$LOG_FILE" 2>/dev/null || echo "   No recent entries"
    else
        echo -e "${YELLOW}📜 No log file found${NC}"
    fi
    echo ""
}

# Function to check database connectivity
check_database() {
    echo -e "${BLUE}🗄️  Database Status:${NC}"

    if command_exists mysql; then
        if mysql -h"localhost" -P"3306" -u"nakdev" -p"Linux@1998" -e "USE ecommerce_db; SELECT 1;" >/dev/null 2>&1; then
            echo -e "   ${GREEN}✅ Database connection: OK${NC}"
        else
            echo -e "   ${RED}❌ Database connection: FAILED${NC}"
        fi
    else
        echo -e "   ${YELLOW}⚠️  MySQL client not found${NC}"
    fi
}

# Main status check
echo -e "${BLUE}🔍 Application Status:${NC}"

# Check PID file
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    echo -e "   📋 PID File: $PID_FILE"
    echo -e "   🔗 Process ID: $PID"

    # Check if process is running
    if ps -p "$PID" > /dev/null 2>&1; then
        echo -e "   ${GREEN}✅ Status: RUNNING${NC}"

        # Get detailed process information
        PROCESS_INFO=$(get_process_info "$PID")
        if [ ! -z "$PROCESS_INFO" ]; then
            echo -e "   📊 Process Details:"
            echo "      $PROCESS_INFO" | awk '{print "      " $1 " " $2 " " $3 " " $4 " " $5 " " $6}'
        fi

        # Test application responsiveness
        echo ""
        echo -e "${BLUE}🌐 Application Responsiveness:${NC}"

        # Test health endpoint
        test_responsiveness "$HEALTH_CHECK_URL" "Health Check"

        # Test API endpoint
        test_responsiveness "$API_CHECK_URL" "API Endpoint"

        # Test main page
        test_responsiveness "http://localhost:$PORT/" "Main Page"

    else
        echo -e "   ${RED}❌ Status: NOT RUNNING (stale PID file)${NC}"
        echo -e "   ${YELLOW}💡 Run './stop.sh' to clean up stale files${NC}"
    fi
else
    echo -e "   📋 PID File: Not found"

    # Check if port is in use
    if check_port; then
        PORT_PID=$(lsof -ti:$PORT)
        echo -e "   ${YELLOW}⚠️  Port $PORT is in use by process $PORT_PID${NC}"
        echo -e "   ${YELLOW}🔍 Application might be running without PID tracking${NC}"

        # Show process information
        PROCESS_INFO=$(get_process_info "$PORT_PID")
        if [ ! -z "$PROCESS_INFO" ]; then
            echo -e "   📊 Process Details:"
            echo "      $PROCESS_INFO" | awk '{print "      " $1 " " $2 " " $3 " " $4 " " $5 " " $6}'
        fi

        # Test responsiveness anyway
        echo ""
        echo -e "${BLUE}🌐 Testing Responsiveness:${NC}"
        test_responsiveness "$API_CHECK_URL" "API Endpoint"

    else
        echo -e "   ${RED}❌ Status: NOT RUNNING${NC}"
    fi
fi

# Get system resources
get_system_resources

# Check database
check_database

# Analyze logs
analyze_logs

# Show quick actions
echo -e "${BLUE}💡 Quick Actions:${NC}"
echo "   🚀 Start:  ./start.sh"
echo "   🛑 Stop:   ./stop.sh"
echo "   📊 Status: ./status.sh"
echo "   📜 Logs:   tail -f $LOG_FILE"
echo "   🌐 Open:   http://localhost:$PORT"
echo "   🔗 API:    http://localhost:$PORT/api"
echo ""

# Show application URLs if running
if [ -f "$PID_FILE" ] && ps -p "$(cat "$PID_FILE")" > /dev/null 2>&1; then
    echo -e "${GREEN}🎉 Application is ready!${NC}"
    echo -e "${BLUE}📍 Access Points:${NC}"
    echo "   🏠 Home:     http://localhost:$PORT/"
    echo "   📦 Products: http://localhost:$PORT/products"
    echo "   🛒 Cart:     http://localhost:$PORT/cart"
    echo "   👑 Admin:    http://localhost:$PORT/admin"
    echo "   🔗 API:      http://localhost:$PORT/api"
    echo ""
fi

echo -e "${CYAN}✨ Status check complete! 🛒${NC}"
