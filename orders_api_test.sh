#!/bin/bash

# Orders API Testing Script for E-commerce Application
# This script tests all 15 Orders API endpoints systematically

BASE_URL="http://localhost:8080/api"
TEST_USER_ID=1  # Using test user ID from database
TEST_PRODUCT_ID=1  # Using test product ID

echo "=========================================="
echo "📋 ORDERS API ENDPOINT TESTING"
echo "=========================================="
echo "Base URL: $BASE_URL"
echo "Test User ID: $TEST_USER_ID"
echo "Test Product ID: $TEST_PRODUCT_ID"
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
        response=$(curl -s -w "\n%{http_code}" -X "$method" -d "$data" "$BASE_URL$endpoint" 2>/dev/null)
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
echo "🛒 SETUP: Prepare Cart for Order Testing"
echo "=========================================="

# First, add some items to cart for order testing
echo "Adding items to cart for order testing..."
curl -s -X POST "$BASE_URL/cart/items" -d "userId=$TEST_USER_ID&productId=$TEST_PRODUCT_ID&quantity=2" > /dev/null
curl -s -X POST "$BASE_URL/cart/items" -d "userId=$TEST_USER_ID&productId=3&quantity=1" > /dev/null

echo "=========================================="
echo "📋 TEST EXECUTION STARTED"
echo "=========================================="

# Test 1: Check if order can be placed
echo "🧪 TEST 1: Check if Order Can Be Placed"
test_endpoint "GET" "/orders/can-place?userId=$TEST_USER_ID" "" "Check if order can be placed"

# Test 2: Validate order for placement
echo "🧪 TEST 2: Validate Order for Placement"
test_endpoint "GET" "/orders/validate?userId=$TEST_USER_ID" "" "Validate order for placement"

# Test 3: Create order from cart
echo "🧪 TEST 3: Create Order from Cart"
test_endpoint "POST" "/orders" "userId=$TEST_USER_ID&shippingAddress=Test+Address+123&billingAddress=Test+Billing+Address+123&orderNotes=Test+order" "Create order from cart" "201"

# Test 4: Get user's orders
echo "🧪 TEST 4: Get User's Orders"
test_endpoint "GET" "/orders?userId=$TEST_USER_ID" "" "Get user's orders"

# Test 5: Get recent orders
echo "🧪 TEST 5: Get Recent Orders"
test_endpoint "GET" "/orders/recent?userId=$TEST_USER_ID&limit=5" "" "Get recent orders for user"

# Test 6: Place the order (complete checkout)
echo "🧪 TEST 6: Place Order"
test_endpoint "POST" "/orders/place" "userId=$TEST_USER_ID" "Place order with payment" "201"

# Get the order ID for further testing
ORDER_ID=$(curl -s "$BASE_URL/orders/recent?userId=$TEST_USER_ID&limit=1" | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')

if [ ! -z "$ORDER_ID" ]; then
    echo "Using Order ID: $ORDER_ID for further tests"

    # Test 7: Get order by ID
    echo "🧪 TEST 7: Get Order by ID"
    test_endpoint "GET" "/orders/$ORDER_ID" "" "Get order by ID"

    # Test 8: Get order by order number (if available)
    echo "🧪 TEST 8: Get Order by Order Number"
    ORDER_NUMBER=$(curl -s "$BASE_URL/orders/$ORDER_ID" | grep -o '"orderNumber":"[^"]*"' | grep -o '"[^"]*"$' | tr -d '"')
    if [ ! -z "$ORDER_NUMBER" ]; then
        test_endpoint "GET" "/orders/number/$ORDER_NUMBER" "" "Get order by order number"
    fi

    # Test 9: Update order status (admin function)
    echo "🧪 TEST 9: Update Order Status"
    test_endpoint "PUT" "/orders/$ORDER_ID/status" "status=SHIPPED" "Update order status to SHIPPED"

    # Test 10: Cancel order
    echo "🧪 TEST 10: Cancel Order"
    test_endpoint "PUT" "/orders/$ORDER_ID/cancel" "" "Cancel order"

    # Test 11: Validate reorder items
    echo "🧪 TEST 11: Validate Reorder Items"
    test_endpoint "GET" "/orders/$ORDER_ID/validate-reorder?userId=$TEST_USER_ID" "" "Validate reorder items"

    # Test 12: Reorder items
    echo "🧪 TEST 12: Reorder Items"
    test_endpoint "POST" "/orders/$ORDER_ID/reorder" "userId=$TEST_USER_ID" "Reorder items from existing order"
fi

# Test 13: Search orders
echo "🧪 TEST 13: Search Orders"
test_endpoint "GET" "/orders/search?searchTerm=order" "" "Search orders"

# Test 14: Get orders by status
echo "🧪 TEST 14: Get Orders by Status"
test_endpoint "GET" "/orders/status/PENDING" "" "Get orders by status"

# Test 15: Get order statistics (admin function)
echo "🧪 TEST 15: Get Order Statistics"
test_endpoint "GET" "/orders/stats" "" "Get order statistics"

echo "=========================================="
echo "📋 EDGE CASES & ERROR SCENARIOS"
echo "=========================================="

# Test 16: Create order with empty cart (should fail)
echo "🧪 TEST 16: Create Order with Empty Cart (Error Case)"
# First clear the cart
curl -s -X DELETE "$BASE_URL/cart" -d "userId=$TEST_USER_ID" > /dev/null
test_endpoint "POST" "/orders" "userId=$TEST_USER_ID&shippingAddress=Test+Address&orderNotes=Test" "Create order with empty cart (should fail)" "400"

# Test 17: Get non-existent order
echo "🧪 TEST 17: Get Non-existent Order"
test_endpoint "GET" "/orders/99999" "" "Get non-existent order" "404"

# Test 18: Update status of non-existent order
echo "🧪 TEST 18: Update Status of Non-existent Order"
test_endpoint "PUT" "/orders/99999/status" "status=DELIVERED" "Update status of non-existent order" "404"

# Test 19: Cancel already cancelled order
echo "🧪 TEST 19: Cancel Already Cancelled Order"
if [ ! -z "$ORDER_ID" ]; then
    test_endpoint "PUT" "/orders/$ORDER_ID/cancel" "" "Cancel already cancelled order" "400"
fi

# Test 20: Advanced search with filters
echo "🧪 TEST 20: Advanced Search Orders"
test_endpoint "GET" "/orders/search-advanced?userId=$TEST_USER_ID&status=PENDING&minAmount=100" "" "Advanced search with filters"

echo "=========================================="
echo "📊 TEST SUMMARY"
echo "=========================================="
echo "✅ Orders API Testing Completed"
echo ""
echo "📈 Test Coverage:"
echo "  • Order Creation & Placement: ✅"
echo "  • Order Retrieval: ✅"
echo "  • Order Status Management: ✅"
echo "  • Order Search & Filtering: ✅"
echo "  • Reorder Functionality: ✅"
echo "  • Error Handling: ✅"
echo "  • Edge Cases: ✅"
echo ""
echo "🎯 Next Steps:"
echo "  • Review test results above"
echo "  • Check application logs for any errors"
echo "  • Proceed to Payments API testing"
echo ""
echo "📋 Total Endpoints Tested: 15"
echo "📋 Edge Cases Tested: 5"
echo "=========================================="
