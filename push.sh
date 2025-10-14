#!/bin/bash

# 🛒 E-commerce Cart System - Enhanced Git Push Script
# Version: 2.0.0
# Description: Builds, tests, commits, and pushes changes to remote repository with comprehensive monitoring

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
LOG_FILE="application.log"
START_TIME=$(date +%s)

# Git configuration
DEFAULT_BRANCH="main"
COMMIT_MESSAGE="Automated commit: $(date +'%Y-%m-%d %H:%M:%S')"

echo -e "${BLUE}🚀 E-commerce Cart System Git Push v2.0${NC}"
echo "======================================"
echo -e "${CYAN}📊 Enhanced Git Operations with Monitoring${NC}"
echo ""

# Function to print progress
print_progress() {
    echo -e "${YELLOW}⏳ $1${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check git repository status
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}❌ Not a git repository${NC}"
        echo -e "${YELLOW}💡 Initialize git repository first: git init${NC}"
        exit 1
    fi

    if ! git remote -v | grep -q origin; then
        echo -e "${RED}❌ No remote origin configured${NC}"
        echo -e "${YELLOW}💡 Add remote repository: git remote add origin <repository-url>${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Git repository and remote configured${NC}"
}

# Function to check for uncommitted changes
check_uncommitted_changes() {
    if git diff --quiet && git diff --staged --quiet; then
        echo -e "${YELLOW}⚠️  No changes to commit${NC}"
        return 1
    else
        echo -e "${GREEN}✅ Found changes to commit${NC}"
        return 0
    fi
}

# Function to show git status
show_git_status() {
    echo -e "${BLUE}📋 Git Status:${NC}"
    echo "----------------------------------------"

    # Show current branch
    BRANCH=$(git branch --show-current)
    echo "Current branch: $BRANCH"

    # Show remote tracking
    REMOTE=$(git remote -v | head -1 | awk '{print $2}')
    echo "Remote repository: $REMOTE"

    # Show uncommitted changes
    if git diff --quiet && git diff --staged --quiet; then
        echo "Working directory: Clean"
    else
        echo "Working directory: Has changes"
        echo ""
        echo -e "${YELLOW}📝 Changes to be committed:${NC}"
        git diff --name-only --cached 2>/dev/null || echo "  No staged changes"
        echo ""
        echo -e "${YELLOW}📝 Unstaged changes:${NC}"
        git diff --name-only 2>/dev/null || echo "  No unstaged changes"
    fi

    # Show recent commits
    echo ""
    echo -e "${YELLOW}📚 Recent commits:${NC}"
    git log --oneline -5
    echo ""
}

# Function to run tests before push
run_tests() {
    echo -e "${BLUE}🧪 Running tests before push...${NC}"

    # Check if Maven is available
    if ! command_exists mvn; then
        echo -e "${YELLOW}⚠️  Maven not found - skipping tests${NC}"
        return 0
    fi

    # Run Maven tests
    print_progress "Running Maven tests..."
    if mvn test > /tmp/test_results.log 2>&1; then
        TESTS_COUNT=$(grep -c "Tests run:" /tmp/test_results.log)
        echo -e "${GREEN}✅ Tests passed (${TESTS_COUNT} tests)${NC}"
        return 0
    else
        echo -e "${RED}❌ Tests failed. Check /tmp/test_results.log for details.${NC}"
        echo -e "${YELLOW}💡 Fix test failures before pushing${NC}"
        return 1
    fi
}

# Function to build application before push
build_application() {
    echo -e "${BLUE}🔨 Building application before push...${NC}"

    # Check if Maven is available
    if ! command_exists mvn; then
        echo -e "${YELLOW}⚠️  Maven not found - skipping build${NC}"
        return 0
    fi

    # Run Maven compile
    print_progress "Compiling application..."
    if mvn compile > /tmp/build_results.log 2>&1; then
        echo -e "${GREEN}✅ Build successful${NC}"
        return 0
    else
        echo -e "${RED}❌ Build failed. Check /tmp/build_results.log for details.${NC}"
        echo -e "${YELLOW}💡 Fix build errors before pushing${NC}"
        return 1
    fi
}

# Function to add files to git
add_files() {
    print_progress "Adding files to git..."

    # Add all changes
    if git add . > /tmp/git_add.log 2>&1; then
        ADDED_COUNT=$(git diff --cached --name-only | wc -l)
        echo -e "${GREEN}✅ Added $ADDED_COUNT files to staging area${NC}"
        return 0
    else
        echo -e "${RED}❌ Failed to add files${NC}"
        return 1
    fi
}

# Function to commit changes
commit_changes() {
    local message="$1"

    print_progress "Committing changes..."

    if git commit -m "$message" > /tmp/git_commit.log 2>&1; then
        COMMIT_HASH=$(git rev-parse --short HEAD)
        echo -e "${GREEN}✅ Changes committed successfully${NC}"
        echo -e "${BLUE}📋 Commit hash: $COMMIT_HASH${NC}"
        echo -e "${BLUE}📝 Commit message: $message${NC}"
        return 0
    else
        echo -e "${RED}❌ Failed to commit changes${NC}"
        echo -e "${YELLOW}💡 Check if there are changes to commit${NC}"
        return 1
    fi
}

# Function to push to remote repository
push_to_remote() {
    print_progress "Pushing to remote repository..."

    # Get current branch
    BRANCH=$(git branch --show-current)

    if git push origin "$BRANCH" > /tmp/git_push.log 2>&1; then
        echo -e "${GREEN}✅ Successfully pushed to origin/$BRANCH${NC}"
        return 0
    else
        echo -e "${RED}❌ Failed to push to remote repository${NC}"
        echo -e "${YELLOW}💡 Check your network connection and remote repository access${NC}"

        # Check if it's an authentication issue
        if grep -q "Permission denied" /tmp/git_push.log || grep -q "fatal: Authentication failed" /tmp/git_push.log; then
            echo -e "${YELLOW}🔐 Authentication issue detected${NC}"
            echo -e "${YELLOW}💡 Make sure you have push access to the repository${NC}"
        fi

        return 1
    fi
}

# Function to show system information
show_system_info() {
    echo -e "${BLUE}📊 System Information:${NC}"
    echo "   Hostname: $(hostname)"
    echo "   User: $(whoami)"
    echo "   Git version: $(git --version)"
    echo ""
}

# Function to create backup reminder
create_backup_reminder() {
    echo -e "${BLUE}💡 Backup reminder:${NC}"
    echo "   Consider creating a backup before major pushes"
    echo "   Current branch: $(git branch --show-current)"
    echo "   Last commit: $(git log --oneline -1)"
    echo ""
}

# Main execution
print_progress "Initializing git push sequence..."

# Show system information
show_system_info

# Check git repository
check_git_repo

# Show current git status
show_git_status

# Check for uncommitted changes
if ! check_uncommitted_changes; then
    echo -e "${YELLOW}🤔 No changes detected. Nothing to push.${NC}"
    echo -e "${YELLOW}💡 Make some changes first, then run this script again${NC}"
    exit 0
fi

# Ask for confirmation
echo -e "${YELLOW}⚠️  Ready to push changes to remote repository${NC}"
read -p "Do you want to continue? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🛑 Push cancelled by user${NC}"
    exit 0
fi

# Run tests before push
if ! run_tests; then
    echo -e "${YELLOW}⚠️  Tests failed. Continue anyway?${NC}"
    read -p "Skip tests and continue? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}🛑 Push cancelled due to test failures${NC}"
        exit 1
    fi
fi

# Build application before push
if ! build_application; then
    echo -e "${YELLOW}⚠️  Build failed. Continue anyway?${NC}"
    read -p "Skip build and continue? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}🛑 Push cancelled due to build failures${NC}"
        exit 1
    fi
fi

# Add files to git
if ! add_files; then
    echo -e "${RED}❌ Failed to add files to git${NC}"
    exit 1
fi

# Ask for commit message
echo ""
echo -e "${YELLOW}📝 Default commit message:${NC} $COMMIT_MESSAGE"
read -p "Use custom commit message? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}📝 Enter your commit message:${NC}"
    read -r CUSTOM_MESSAGE
    COMMIT_MSG="$CUSTOM_MESSAGE"
else
    COMMIT_MSG="$COMMIT_MESSAGE"
fi

# Commit changes
if ! commit_changes "$COMMIT_MSG"; then
    echo -e "${RED}❌ Failed to commit changes${NC}"
    exit 1
fi

# Push to remote
if ! push_to_remote; then
    echo -e "${RED}❌ Failed to push to remote repository${NC}"
    exit 1
fi

# Create backup reminder
create_backup_reminder

# Calculate execution time
END_TIME=$(date +%s)
EXECUTION_TIME=$((END_TIME - START_TIME))

# Final success message
echo ""
echo -e "${GREEN}🎉 Git push completed successfully!${NC}"
echo -e "${BLUE}📊 Execution time: ${EXECUTION_TIME}s${NC}"
echo ""
echo -e "${YELLOW}📋 What was pushed:${NC}"
echo "   Branch: $(git branch --show-current)"
echo "   Commit: $(git log --oneline -1)"
echo "   Files: $(git diff --name-only HEAD~1 HEAD | wc -l) files changed"
echo ""
echo -e "${GREEN}🚀 Push complete! Your changes are now live! 🛒${NC}"

# Optional: Show recent activity
echo ""
echo -e "${BLUE}📈 Recent git activity:${NC}"
git log --oneline -3
echo ""
echo -e "${YELLOW}💡 Next steps:${NC}"
echo "   🔄 To push more changes: ./push.sh"
echo "   🌿 To switch branch: git checkout <branch-name>"
echo "   📦 To deploy: ./start.sh"
