#!/bin/bash

# 🛒 E-commerce Cart System - Enhanced Shutdown Script
# Version: 2.0.0
# Description: Gracefully stops the running Spring Boot application with comprehensive cleanup

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
START_TIME=$(date +%s)

echo -e "${BLUE}🛑 Stopping E-commerce Cart System v2.0${NC}"
echo "======================================"
echo -e "${CYAN}📊 Enhanced Shutdown with Monitoring${NC}"
echo ""

# Function to print progress
print_progress() {
    echo -e "${YELLOW}⏳ $1${NC}"
}

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
        local info=$(ps -p "$pid" -o pid,ppid,pcpu,pmem,etime,command | tail -1)
        echo "$info"
    fi
}

# Function to stop process gracefully
stop_process() {
    local pid=$1
    local attempt=$2

    if [ $attempt -eq 1 ]; then
        echo -e "${YELLOW}🔄 Attempting graceful shutdown (SIGTERM)...${NC}"
        kill "$pid"
    else
        echo -e "${YELLOW}🔪 Force stopping application (SIGKILL)...${NC}"
        kill -9 "$pid"
    fi

    # Wait for process to stop
    for i in {1..15}; do
        if ! ps -p "$pid" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Process $pid stopped successfully${NC}"
            return 0
        fi
        echo -n "."
        sleep 1
    done

    echo -e "${RED}❌ Process $pid did not stop within 15 seconds${NC}"
    return 1
}

# Function to get system resource usage before shutdown
get_resource_usage() {
    echo -e "${BLUE}📊 Resource usage before shutdown:${NC}"

    # Get application memory usage if PID exists
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            MEMORY=$(ps -p "$PID" -o rss= | awk '{print $1/1024 "MB"}')
            CPU=$(ps -p "$PID" -o pcpu= | awk '{print $1"%"}')
            echo "   Application Memory: $MEMORY"
            echo "   Application CPU: $CPU"
        fi
    fi

    # Get system memory
    if command_exists free; then
        FREE_MEM=$(free -h | awk 'NR==2{print $7}')
        echo "   System Free Memory: $FREE_MEM"
    fi

    echo ""
}

# Function to cleanup resources
cleanup_resources() {
    print_progress "Cleaning up resources..."

    # Remove PID file
    if [ -f "$PID_FILE" ]; then
        rm -f "$PID_FILE"
        echo -e "${GREEN}✅ Removed PID file: $PID_FILE${NC}"
    fi

    # Check if port is still in use
    if check_port; then
        echo -e "${YELLOW}⚠️  Port $PORT is still in use. Finding remaining processes...${NC}"

        # Find and kill any remaining Java processes for this app
        PIDS=$(ps aux | grep -E "(ecommerce|spring-boot)" | grep -v grep | awk '{print $2}')
        if [ ! -z "$PIDS" ]; then
            echo -e "${YELLOW}🔍 Found additional processes: $PIDS${NC}"
            for pid in $PIDS; do
                echo -e "${YELLOW}🔪 Force killing process $pid...${NC}"
                kill -9 "$pid" 2>/dev/null
                sleep 1
            done
        fi

        # Final check
        sleep 2
        if check_port; then
            PORT_PID=$(lsof -ti:$PORT)
            echo -e "${RED}❌ Port $PORT still in use by process $PORT_PID${NC}"
            echo -e "${YELLOW}💡 Manual intervention may be required${NC}"
        fi
    else
        echo -e "${GREEN}✅ Port $PORT is now free${NC}"
    fi
}

# Function to create backup reminder
create_backup_reminder() {
    if [ -f "$LOG_FILE" ]; then
        LOG_SIZE=$(du -h "$LOG_FILE" | cut -f1)
        echo -e "${BLUE}📋 Log file size:${NC} $LOG_SIZE"
        echo -e "${YELLOW}💡 Consider backing up logs if needed: cp $LOG_FILE $LOG_FILE.backup.${NC}"
    fi
}

# Main stop logic
print_progress "Checking application status..."

# Get resource usage before shutdown
get_resource_usage

# Check if PID file exists
if [ ! -f "$PID_FILE" ]; then
    echo -e "${YELLOW}⚠️  PID file not found. Checking if application is running...${NC}"

    # Check if port is in use
    if check_port; then
        echo -e "${YELLOW}📡 Application is running but PID file is missing${NC}"
        print_progress "Finding running processes..."

        # Find Java processes related to our application
        JAVA_PIDS=$(ps aux | grep -E "(spring-boot|java.*ecommerce)" | grep -v grep | awk '{print $2}')

        if [ -z "$JAVA_PIDS" ]; then
            echo -e "${YELLOW}🔍 Checking for any process using port $PORT...${NC}"
            PORT_PID=$(lsof -ti:$PORT)
            if [ ! -z "$PORT_PID" ]; then
                echo -e "${YELLOW}📡 Found process $PORT_PID using port $PORT${NC}"
                JAVA_PIDS="$PORT_PID"
            fi
        fi

        if [ ! -z "$JAVA_PIDS" ]; then
            echo -e "${YELLOW}🛑 Stopping found processes: $JAVA_PIDS${NC}"
            for pid in $JAVA_PIDS; do
                echo -e "${BLUE}📋 Process info: $(get_process_info $pid)${NC}"
                stop_process "$pid" 1
            done
        else
            echo -e "${GREEN}✅ No running application found${NC}"
        fi
    else
        echo -e "${GREEN}✅ Application is not running${NC}"
    fi
else
    # PID file exists, read it
    PID=$(cat "$PID_FILE")
    echo -e "${BLUE}📋 Found PID file with process ID: $PID${NC}"

    # Show process information
    if ps -p "$PID" > /dev/null 2>&1; then
        echo -e "${BLUE}📊 Process details:${NC}"
        get_process_info "$PID" | awk '{print "   " $0}'
        echo ""

        print_progress "Stopping process $PID..."

        # Attempt graceful shutdown
        if stop_process "$PID" 1; then
            echo -e "${GREEN}✅ Application stopped gracefully${NC}"
        else
            echo -e "${YELLOW}⚠️  Graceful shutdown failed, trying force kill...${NC}"
            if stop_process "$PID" 2; then
                echo -e "${GREEN}✅ Application force stopped${NC}"
            else
                echo -e "${RED}❌ Failed to stop application${NC}"
                exit 1
            fi
        fi
    else
        echo -e "${YELLOW}⚠️  Process $PID is not running (stale PID file)${NC}"
    fi
fi

# Cleanup resources
cleanup_resources

# Create backup reminder
create_backup_reminder

# Calculate shutdown time
END_TIME=$(date +%s)
SHUTDOWN_TIME=$((END_TIME - START_TIME))

# Final status check
echo ""
echo -e "${GREEN}🎉 E-commerce Cart System stopped successfully!${NC}"
echo -e "${BLUE}📝 Application logs:${NC} $LOG_FILE"
echo -e "${BLUE}🚀 To start again:${NC} ./start.sh"
echo -e "${BLUE}📊 To check status:${NC} ./status.sh"
echo ""
echo -e "${YELLOW}⏱️  Shutdown time: ${SHUTDOWN_TIME}s${NC}"
echo ""
echo -e "${GREEN}✨ Shutdown complete! 🛒${NC}"
