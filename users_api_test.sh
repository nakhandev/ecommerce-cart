#!/bin/bash

# Users API Testing Script for E-commerce Application
# This script tests all 10 Users API endpoints systematically

BASE_URL="http://localhost:8080/api"

echo "=========================================="
echo "👥 USERS API ENDPOINT TESTING"
echo "=========================================="
echo "Base URL: $BASE_URL"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to make API calls and check response
test_endpoint() {
    local method=$1
    local endpoint=$2
    local data=$3
    local description=$4
    local expected_status=${5:-200}

    echo -n "Testing: $description... "

    if [ "$method" = "GET" ]; then
        response=$(curl -s -w "\n%{http_code}" "$BASE_URL$endpoint" 2>/dev/null)
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" -H "Content-Type: application/json" -d "$data" "$BASE_URL$endpoint" 2>/dev/null)
    fi

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n -1)

    if [ "$http_code" = "$expected_status" ]; then
        echo -e "${GREEN}✅ PASS${NC} (HTTP $http_code)"
        echo "Response: $body"
    else
        echo -e "${RED}❌ FAIL${NC} (Expected HTTP $expected_status, got $http_code)"
        echo "Response: $body"
    fi
    echo ""
}

echo "=========================================="
echo "📋 TEST EXECUTION STARTED"
echo "=========================================="

# Test 1: Register new user
echo "🧪 TEST 1: Register New User"
USER_DATA='{
  "username": "testuser'$(date +%s)'",
  "email": "test'$(date +%s)'@example.com",
  "password": "TestPass123!",
  "confirmPassword": "TestPass123!",
  "firstName": "Test",
  "lastName": "User",
  "phoneNumber": "+1234567890"
}'
test_endpoint "POST" "/users/register" "$USER_DATA" "Register new user" "201"

# Test 2: Get user profile
echo "🧪 TEST 2: Get User Profile"
test_endpoint "GET" "/users/profile?userId=1" "" "Get user profile"

# Test 3: Update user profile
echo "🧪 TEST 3: Update User Profile"
UPDATE_DATA='{
  "firstName": "Updated",
  "lastName": "Name",
  "phoneNumber": "+1987654321",
  "email": "updated@example.com"
}'
test_endpoint "PUT" "/users/profile?userId=1" "$UPDATE_DATA" "Update user profile"

# Test 4: Get all users (admin function)
echo "🧪 TEST 4: Get All Users"
test_endpoint "GET" "/users" "" "Get all users"

# Test 5: Get user by ID
echo "🧪 TEST 5: Get User by ID"
test_endpoint "GET" "/users/1" "" "Get user by ID"

# Test 6: Search users
echo "🧪 TEST 6: Search Users"
test_endpoint "GET" "/users/search?searchTerm=test" "" "Search users"

# Test 7: Activate user (admin function)
echo "🧪 TEST 7: Activate User"
test_endpoint "PUT" "/users/1/activate" "" "Activate user"

# Test 8: Deactivate user (admin function)
echo "🧪 TEST 8: Deactivate User"
test_endpoint "PUT" "/users/1/deactivate" "" "Deactivate user"

# Test 9: Change user role (admin function)
echo "🧪 TEST 9: Change User Role"
test_endpoint "PUT" "/users/1/role?role=ADMIN" "" "Change user role to ADMIN"

# Test 10: Get user statistics (admin function)
echo "🧪 TEST 10: Get User Statistics"
test_endpoint "GET" "/users/stats" "" "Get user statistics"

echo "=========================================="
echo "👥 EDGE CASES & ERROR SCENARIOS"
echo "=========================================="

# Test 11: Register user with existing email (should fail)
echo "🧪 TEST 11: Register User with Existing Email (Error Case)"
DUPLICATE_EMAIL_DATA='{
  "username": "duplicateuser",
  "email": "test@example.com",
  "password": "TestPass123!",
  "confirmPassword": "TestPass123!",
  "firstName": "Duplicate",
  "lastName": "User",
  "phoneNumber": "+1234567890"
}'
test_endpoint "POST" "/users/register" "$DUPLICATE_EMAIL_DATA" "Register user with existing email (should fail)" "400"

# Test 12: Register user with mismatched passwords (should fail)
echo "🧪 TEST 12: Register User with Mismatched Passwords (Error Case)"
MISMATCH_DATA='{
  "username": "mismatchuser",
  "email": "mismatch@example.com",
  "password": "TestPass123!",
  "confirmPassword": "DifferentPass456!",
  "firstName": "Mismatch",
  "lastName": "User",
  "phoneNumber": "+1234567890"
}'
test_endpoint "POST" "/users/register" "$MISMATCH_DATA" "Register user with mismatched passwords (should fail)" "400"

# Test 13: Get non-existent user profile
echo "🧪 TEST 13: Get Non-existent User Profile"
test_endpoint "GET" "/users/profile?userId=99999" "" "Get non-existent user profile" "404"

# Test 14: Get non-existent user by ID
echo "🧪 TEST 14: Get Non-existent User by ID"
test_endpoint "GET" "/users/99999" "" "Get non-existent user by ID" "404"

# Test 15: Update profile of non-existent user
echo "🧪 TEST 15: Update Profile of Non-existent User"
test_endpoint "PUT" "/users/profile?userId=99999" "$UPDATE_DATA" "Update profile of non-existent user" "404"

# Test 16: Activate non-existent user
echo "🧪 TEST 16: Activate Non-existent User"
test_endpoint "PUT" "/users/99999/activate" "" "Activate non-existent user" "404"

# Test 17: Deactivate non-existent user
echo "🧪 TEST 17: Deactivate Non-existent User"
test_endpoint "PUT" "/users/99999/deactivate" "" "Deactivate non-existent user" "404"

# Test 18: Change role of non-existent user
echo "🧪 TEST 18: Change Role of Non-existent User"
test_endpoint "PUT" "/users/99999/role?role=CUSTOMER" "" "Change role of non-existent user" "404"

# Test 19: Delete user (admin function)
echo "🧪 TEST 19: Delete User"
test_endpoint "DELETE" "/users/2" "" "Delete user"

# Test 20: Search users with special characters
echo "🧪 TEST 20: Search Users with Special Characters"
test_endpoint "GET" "/users/search?searchTerm=test@special#chars" "" "Search users with special characters"

echo "=========================================="
echo "📊 TEST SUMMARY"
echo "=========================================="
echo "✅ Users API Testing Completed"
echo ""
echo "📈 Test Coverage:"
echo "  • User Registration: ✅"
echo "  • Profile Management: ✅"
echo "  • User Search & Retrieval: ✅"
echo "  • Role Management: ✅"
echo "  • User Activation/Deactivation: ✅"
echo "  • Error Handling: ✅"
echo "  • Edge Cases: ✅"
echo ""
echo "🎯 Next Steps:"
echo "  • Review test results above"
echo "  • Check application logs for any errors"
echo "  • Proceed to Complete User Workflow Testing"
echo ""
echo "📋 Total Endpoints Tested: 10"
echo "📋 Edge Cases Tested: 10"
echo "=========================================="
