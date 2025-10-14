#!/bin/bash

# 🛒 E-commerce Cart System - Enhanced Startup Script
# Version: 2.0.0
# Description: Builds and starts the Spring Boot application with comprehensive monitoring

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="ecommerce-cart"
MAIN_CLASS="com.nakhandev.ecommercecart.EcommerceCartApplication"
PID_FILE="application.pid"
LOG_FILE="application.log"
PORT=8080
START_TIME=$(date +%s)

# Enhanced configuration
DB_HOST="localhost"
DB_PORT="3306"
DB_NAME="ecommerce_db"
HEALTH_CHECK_URL="http://localhost:$PORT/actuator/health"
API_CHECK_URL="http://localhost:$PORT/api/products"

echo -e "${BLUE}🛒 Starting E-commerce Cart System v2.0${NC}"
echo "=========================================="
echo -e "${CYAN}📊 Enhanced Startup with Monitoring${NC}"
echo ""

# Function to print progress
print_progress() {
    echo -e "${YELLOW}⏳ $1${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check system resources
check_system_resources() {
    echo -e "${BLUE}🔍 Checking system resources...${NC}"

    # Check available memory
    if command_exists free; then
        MEM_GB=$(free -g | awk 'NR==2{printf "%.0f", $7/1024}')
        if [ "$MEM_GB" -lt 1 ]; then
            echo -e "${YELLOW}⚠️  Warning: Low available memory (${MEM_GB}GB)${NC}"
        else
            echo -e "${GREEN}✅ Memory: ${MEM_GB}GB available${NC}"
        fi
    fi

    # Check disk space
    if command_exists df; then
        DISK_USAGE=$(df . | awk 'NR==2{print $5}' | sed 's/%//')
        if [ "$DISK_USAGE" -gt 90 ]; then
            echo -e "${RED}❌ Disk usage too high: ${DISK_USAGE}%${NC}"
            exit 1
        elif [ "$DISK_USAGE" -gt 80 ]; then
            echo -e "${YELLOW}⚠️  High disk usage: ${DISK_USAGE}%${NC}"
        else
            echo -e "${GREEN}✅ Disk usage: ${DISK_USAGE}%${NC}"
        fi
    fi
}

# Function to check database connectivity
check_database() {
    echo -e "${BLUE}🗄️  Checking database connectivity...${NC}"

    if command_exists mysql; then
        if mysql -h"$DB_HOST" -P"$DB_PORT" -u"nakdev" -p"Linux@1998" -e "USE $DB_NAME; SELECT 1;" >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Database connection successful${NC}"
            return 0
        else
            echo -e "${RED}❌ Database connection failed${NC}"
            echo -e "${YELLOW}💡 Make sure MySQL is running and credentials are correct${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️  MySQL client not found - skipping database check${NC}"
        return 0
    fi
}

# Function to check if port is in use
check_port() {
    if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; then
        return 0  # Port is in use
    else
        return 1  # Port is free
    fi
}

# Function to kill process by PID file
kill_by_pid_file() {
    if [ -f "$PID_FILE" ]; then
        OLD_PID=$(cat "$PID_FILE")
        if ps -p "$OLD_PID" > /dev/null 2>&1; then
            echo -e "${YELLOW}🛑 Stopping existing application (PID: $OLD_PID)...${NC}"
            kill "$OLD_PID"
            sleep 3
            if ps -p "$OLD_PID" > /dev/null 2>&1; then
                echo -e "${YELLOW}🔪 Force killing application...${NC}"
                kill -9 "$OLD_PID"
                sleep 2
            fi
        fi
        rm -f "$PID_FILE"
    fi
}

# Function to wait for application to start
wait_for_start() {
    echo -e "${YELLOW}⏳ Waiting for application to start...${NC}"
    for i in {1..30}; do
        echo -n "."

        # Check both health endpoint and API endpoint
        if curl -s "$HEALTH_CHECK_URL" >/dev/null 2>&1 || curl -s "$API_CHECK_URL" >/dev/null 2>&1; then
            echo ""
            echo -e "${GREEN}✅ Application started successfully!${NC}"
            return 0
        fi

        sleep 2
    done
    echo ""
    echo -e "${RED}❌ Application failed to start within 60 seconds${NC}"
    return 1
}

# Function to show system information
show_system_info() {
    echo -e "${BLUE}📊 System Information:${NC}"
    echo "   Hostname: $(hostname)"
    echo "   Platform: $(uname -s) $(uname -m)"
    echo "   CPU Cores: $(nproc 2>/dev/null || echo 'Unknown')"
    echo "   Load Average: $(uptime | awk -F'load average:' '{print $2}' | xargs)"
    echo ""
}

# Main execution
print_progress "Initializing startup sequence..."

# Show system information
show_system_info

# Check system resources
check_system_resources

# Check database connectivity
if ! check_database; then
    echo -e "${YELLOW}⚠️  Continuing without database check...${NC}"
fi

# Check prerequisites
print_progress "Checking prerequisites..."

# Check Java
if ! command_exists java; then
    echo -e "${RED}❌ Java is not installed. Please install Java 11 or higher.${NC}"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | head -n1 | cut -d'"' -f2 | sed 's/^1\.//' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt "11" ]; then
    echo -e "${RED}❌ Java 11 or higher is required. Current version: $(java -version 2>&1 | head -n1)${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Java $JAVA_VERSION found${NC}"

# Check Maven
if ! command_exists mvn; then
    echo -e "${RED}❌ Maven is not installed. Please install Maven 3.6 or higher.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Maven found${NC}"

# Check port availability
if check_port; then
    echo -e "${YELLOW}⚠️  Port $PORT is already in use. Stopping existing application...${NC}"
    kill_by_pid_file
fi

# Clean and build the application
print_progress "Building application..."
if ! mvn clean compile > "$LOG_FILE" 2>&1; then
    echo -e "${RED}❌ Build failed. Check $LOG_FILE for details.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Build completed successfully${NC}"

# Start the application
print_progress "Starting application..."
echo -e "${YELLOW}📍 Application will be available at: http://localhost:$PORT${NC}"
echo -e "${YELLOW}🔗 API endpoints: http://localhost:$PORT/api/*${NC}"
echo -e "${YELLOW}📊 Health check: $HEALTH_CHECK_URL${NC}"
echo ""

# Start in background and save PID
nohup mvn spring-boot:run >> "$LOG_FILE" 2>&1 &
NEW_PID=$!

# Save PID to file
echo $NEW_PID > "$PID_FILE"
echo -e "${GREEN}✅ Application started with PID: $NEW_PID${NC}"

# Wait for application to start
if wait_for_start; then
    END_TIME=$(date +%s)
    STARTUP_TIME=$((END_TIME - START_TIME))

    echo ""
    echo -e "${GREEN}🎉 E-commerce Cart System is running!${NC}"
    echo -e "${BLUE}📊 Dashboard:${NC} http://localhost:$PORT"
    echo -e "${BLUE}🔗 API Base:${NC} http://localhost:$PORT/api"
    echo -e "${BLUE}📝 Application logs:${NC} $LOG_FILE"
    echo -e "${BLUE}🛑 To stop:${NC} ./stop.sh"
    echo -e "${BLUE}📊 To check status:${NC} ./status.sh"
    echo ""
    echo -e "${YELLOW}⏱️  Startup time: ${STARTUP_TIME}s${NC}"
    echo ""
    echo -e "${YELLOW}💡 Access URLs:${NC}"
    echo "   🏠 Home: http://localhost:$PORT/"
    echo "   📦 Products: http://localhost:$PORT/products"
    echo "   🛒 Cart: http://localhost:$PORT/cart"
    echo "   👑 Admin: http://localhost:$PORT/admin"
    echo ""
    echo -e "${GREEN}🚀 Ready for production! 🛒${NC}"
else
    echo -e "${RED}❌ Failed to start application. Check $LOG_FILE for details.${NC}"
    rm -f "$PID_FILE"
    exit 1
fi
