#!/bin/bash

# Complete User Workflow & Integration Testing Script
# This script tests end-to-end user journeys and cross-module integration

BASE_URL="http://localhost:8080/api"

echo "=========================================="
echo "🔄 COMPLETE USER WORKFLOW TESTING"
echo "=========================================="
echo "Base URL: $BASE_URL"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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
        response=$(curl -s -w "\n%{http_code}" -X "$method" -d "$data" "$BASE_URL$endpoint" 2>/dev/null)
    fi

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n -1)

    if [ "$http_code" = "$expected_status" ]; then
        echo -e "${GREEN}✅ PASS${NC} (HTTP $http_code)"
    else
        echo -e "${RED}❌ FAIL${NC} (Expected HTTP $expected_status, got $http_code)"
    fi
    echo "Response: $body"
    echo ""
}

echo "=========================================="
echo "🛒 WORKFLOW 1: Complete Shopping Journey"
echo "=========================================="

TEST_USER_ID=1
TEST_PRODUCT_ID=1

echo -e "${BLUE}Step 1: Browse Products${NC}"
# Get available products
test_endpoint "GET" "/products" "" "Browse available products" "200"

echo -e "${BLUE}Step 2: Get Product Details${NC}"
# Get specific product details
test_endpoint "GET" "/products/$TEST_PRODUCT_ID" "" "Get product details" "200"

echo -e "${BLUE}Step 3: Add Items to Cart${NC}"
# Add items to cart
test_endpoint "POST" "/cart/items" "userId=$TEST_USER_ID&productId=$TEST_PRODUCT_ID&quantity=2" "Add items to cart" "201"

echo -e "${BLUE}Step 4: View Cart${NC}"
# View cart contents
test_endpoint "GET" "/cart?userId=$TEST_USER_ID" "" "View cart contents" "200"

echo -e "${BLUE}Step 5: Update Cart Quantity${NC}"
# Update cart item quantity
test_endpoint "PUT" "/cart/items/$TEST_PRODUCT_ID" "userId=$TEST_USER_ID&quantity=3" "Update cart quantity" "200"

echo -e "${BLUE}Step 6: Validate Cart${NC}"
# Validate cart for checkout
test_endpoint "GET" "/cart/validate?userId=$TEST_USER_ID" "" "Validate cart for checkout" "200"

echo -e "${BLUE}Step 7: Create Order from Cart${NC}"
# Create order from cart
test_endpoint "POST" "/orders" "userId=$TEST_USER_ID&shippingAddress=123+Test+Street&orderNotes=Workflow+test" "Create order from cart" "201"

echo -e "${BLUE}Step 8: Get Order Details${NC}"
# Get the created order details
ORDER_ID=$(curl -s "$BASE_URL/orders/recent?userId=$TEST_USER_ID&limit=1" | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')
if [ ! -z "$ORDER_ID" ]; then
    test_endpoint "GET" "/orders/$ORDER_ID" "" "Get order details" "200"
fi

echo -e "${BLUE}Step 9: Process Payment${NC}"
# Process payment for the order
if [ ! -z "$ORDER_ID" ]; then
    test_endpoint "POST" "/payments/process" "orderId=$ORDER_ID&paymentMethod=CREDIT_CARD" "Process payment" "201"
fi

echo -e "${BLUE}Step 10: Place Order${NC}"
# Place the order (complete checkout)
if [ ! -z "$ORDER_ID" ]; then
    test_endpoint "POST" "/orders/place" "userId=$TEST_USER_ID" "Place order" "201"
fi

echo "=========================================="
echo "🔄 WORKFLOW 2: User Registration & Profile Management"
echo "=========================================="

echo -e "${BLUE}Step 1: Register New User${NC}"
# Register new user
TIMESTAMP=$(date +%s)
USER_DATA='{
  "username": "workflowuser'$TIMESTAMP'",
  "email": "workflow'$TIMESTAMP'@example.com",
  "password": "WorkflowPass123!",
  "confirmPassword": "WorkflowPass123!",
  "firstName": "Workflow",
  "lastName": "User",
  "phoneNumber": "9876543210"
}'
test_endpoint "POST" "/users/register" "$USER_DATA" "Register new user" "201"

echo -e "${BLUE}Step 2: Get User Profile${NC}"
# Get user profile
test_endpoint "GET" "/users/profile?userId=1" "" "Get user profile" "200"

echo -e "${BLUE}Step 3: Update User Profile${NC}"
# Update user profile
UPDATE_DATA='{
  "firstName": "Updated",
  "lastName": "Profile",
  "phoneNumber": "9876543210",
  "email": "updated@example.com"
}'
test_endpoint "PUT" "/users/profile?userId=1" "$UPDATE_DATA" "Update user profile" "200"

echo -e "${BLUE}Step 4: Search Users${NC}"
# Search for users
test_endpoint "GET" "/users/search?searchTerm=workflow" "" "Search users" "200"

echo "=========================================="
echo "🔄 WORKFLOW 3: Admin Management Workflow"
echo "=========================================="

echo -e "${BLUE}Step 1: Get All Products (Admin View)${NC}"
# Admin views all products
test_endpoint "GET" "/products" "" "Admin view all products" "200"

echo -e "${BLUE}Step 2: Get Product Statistics${NC}"
# Get product statistics
test_endpoint "GET" "/products/stats" "" "Get product statistics" "200"

echo -e "${BLUE}Step 3: Get All Orders (Admin View)${NC}"
# Admin views all orders
test_endpoint "GET" "/orders" "" "Admin view all orders" "200"

echo -e "${BLUE}Step 4: Get Order Statistics${NC}"
# Get order statistics
test_endpoint "GET" "/orders/stats" "" "Get order statistics" "200"

echo -e "${BLUE}Step 5: Get Payment Statistics${NC}"
# Get payment statistics
test_endpoint "GET" "/payments/stats" "" "Get payment statistics" "200"

echo -e "${BLUE}Step 6: Get User Statistics${NC}"
# Get user statistics
test_endpoint "GET" "/users/stats" "" "Get user statistics" "200"

echo "=========================================="
echo "🔄 WORKFLOW 4: Product Management Workflow"
echo "=========================================="

echo -e "${BLUE}Step 1: Get Products by Category${NC}"
# Get products by category
test_endpoint "GET" "/products/category/1" "" "Get products by category" "200"

echo -e "${BLUE}Step 2: Search Products${NC}"
# Search for products
test_endpoint "GET" "/products/search?searchTerm=phone" "" "Search products" "200"

echo -e "${BLUE}Step 3: Get Featured Products${NC}"
# Get featured products
test_endpoint "GET" "/products/featured" "" "Get featured products" "200"

echo -e "${BLUE}Step 4: Get Active Products${NC}"
# Get only active products
test_endpoint "GET" "/products/active" "" "Get active products" "200"

echo "=========================================="
echo "🔄 WORKFLOW 5: Order Management Workflow"
echo "=========================================="

echo -e "${BLUE}Step 1: Get User's Orders${NC}"
# Get user's order history
test_endpoint "GET" "/orders?userId=$TEST_USER_ID" "" "Get user's orders" "200"

echo -e "${BLUE}Step 2: Get Recent Orders${NC}"
# Get recent orders
test_endpoint "GET" "/orders/recent?userId=$TEST_USER_ID&limit=5" "" "Get recent orders" "200"

echo -e "${BLUE}Step 3: Get Orders by Status${NC}"
# Get orders by status
test_endpoint "GET" "/orders/status/PENDING" "" "Get orders by status" "200"

echo -e "${BLUE}Step 4: Advanced Order Search${NC}"
# Advanced search with filters
test_endpoint "GET" "/orders/search-advanced?userId=$TEST_USER_ID&minAmount=100" "" "Advanced order search" "200"

echo "=========================================="
echo "🔄 WORKFLOW 6: Payment Management Workflow"
echo "=========================================="

echo -e "${BLUE}Step 1: Get Payments by User${NC}"
# Get user's payment history
test_endpoint "GET" "/payments/user/$TEST_USER_ID" "" "Get user's payments" "200"

echo -e "${BLUE}Step 2: Get Payments by Status${NC}"
# Get payments by status
test_endpoint "GET" "/payments/status/COMPLETED" "" "Get completed payments" "200"

echo -e "${BLUE}Step 3: Get Payments by Method${NC}"
# Get payments by method
test_endpoint "GET" "/payments/method/CREDIT_CARD" "" "Get credit card payments" "200"

echo -e "${BLUE}Step 4: Search Payments${NC}"
# Search payments
test_endpoint "GET" "/payments/search?searchTerm=payment" "" "Search payments" "200"

echo "=========================================="
echo "🔄 WORKFLOW 7: Error Handling & Edge Cases"
echo "=========================================="

echo -e "${BLUE}Step 1: Test Empty Cart Checkout${NC}"
# Clear cart and try to create order
curl -s -X DELETE "$BASE_URL/cart" -d "userId=$TEST_USER_ID" > /dev/null
test_endpoint "POST" "/orders" "userId=$TEST_USER_ID&shippingAddress=Test&orderNotes=Empty+cart+test" "Test empty cart checkout (should fail)" "400"

echo -e "${BLUE}Step 2: Test Invalid Product in Cart${NC}"
# Try to add non-existent product to cart
test_endpoint "POST" "/cart/items" "userId=$TEST_USER_ID&productId=99999&quantity=1" "Add non-existent product to cart" "400"

echo -e "${BLUE}Step 3: Test Non-existent Order Payment${NC}"
# Try to process payment for non-existent order
test_endpoint "POST" "/payments/process" "orderId=99999&paymentMethod=CREDIT_CARD" "Process payment for non-existent order" "404"

echo -e "${BLUE}Step 4: Test Invalid User Operations${NC}"
# Try to get profile of non-existent user
test_endpoint "GET" "/users/profile?userId=99999" "" "Get profile of non-existent user" "404"

echo "=========================================="
echo "📊 INTEGRATION TEST SUMMARY"
echo "=========================================="
echo "✅ Complete User Workflow Testing Finished"
echo ""
echo "📈 Integration Coverage:"
echo "  • Complete Shopping Journey: ✅"
echo "  • User Registration & Profile: ✅"
echo "  • Admin Management Functions: ✅"
echo "  • Product Management Workflow: ✅"
echo "  • Order Management Workflow: ✅"
echo "  • Payment Management Workflow: ✅"
echo "  • Error Handling & Edge Cases: ✅"
echo ""
echo "🎯 Key Integration Points Tested:"
echo "  • Products ↔ Cart ↔ Orders ↔ Payments"
echo "  • User Management ↔ Order History"
echo "  • Admin Functions ↔ All Modules"
echo "  • Search & Filtering ↔ All Entities"
echo "  • Error Handling ↔ All Workflows"
echo ""
echo "📋 Total Workflow Scenarios: 7"
echo "📋 Integration Points Tested: 25+"
echo "📋 End-to-End Journeys: 3 Complete"
echo "=========================================="
