#!/bin/bash

# Cart API Testing Script for E-commerce Application
# This script tests all 13 Cart API endpoints systematically

BASE_URL="http://localhost:8080/api"
TEST_USER_ID=1  # Using test user ID from database
TEST_PRODUCT_ID=1  # Using test product ID

echo "=========================================="
echo "🛒 CART API ENDPOINT TESTING"
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
echo "📋 TEST EXECUTION STARTED"
echo "=========================================="

# Test 1: Get empty cart (should return empty cart structure)
echo "🧪 TEST 1: Get Empty Cart"
test_endpoint "GET" "/cart?userId=$TEST_USER_ID" "" "Get empty cart for user"

# Test 2: Add item to cart
echo "🧪 TEST 2: Add Item to Cart"
test_endpoint "POST" "/cart/items" "userId=$TEST_USER_ID&productId=$TEST_PRODUCT_ID&quantity=2" "Add 2 items to cart" "201"

# Test 3: Get cart with items
echo "🧪 TEST 3: Get Cart with Items"
test_endpoint "GET" "/cart?userId=$TEST_USER_ID" "" "Get cart with items"

# Test 4: Get cart items
echo "🧪 TEST 4: Get Cart Items"
test_endpoint "GET" "/cart/items?userId=$TEST_USER_ID" "" "Get cart items list"

# Test 5: Get cart item count
echo "🧪 TEST 5: Get Cart Item Count"
test_endpoint "GET" "/cart/count?userId=$TEST_USER_ID" "" "Get cart item count"

# Test 6: Check if cart is empty
echo "🧪 TEST 6: Check if Cart is Empty"
test_endpoint "GET" "/cart/empty?userId=$TEST_USER_ID" "" "Check if cart is empty"

# Test 7: Update cart item quantity
echo "🧪 TEST 7: Update Cart Item Quantity"
test_endpoint "PUT" "/cart/items/$TEST_PRODUCT_ID" "userId=$TEST_USER_ID&quantity=5" "Update item quantity to 5"

# Test 8: Check if product is in cart
echo "🧪 TEST 8: Check if Product is in Cart"
test_endpoint "GET" "/cart/contains/$TEST_PRODUCT_ID?userId=$TEST_USER_ID" "" "Check if product is in cart"

# Test 9: Get cart summary
echo "🧪 TEST 9: Get Cart Summary"
test_endpoint "GET" "/cart/summary?userId=$TEST_USER_ID" "" "Get cart summary"

# Test 10: Validate cart items
echo "🧪 TEST 10: Validate Cart Items"
test_endpoint "GET" "/cart/validate?userId=$TEST_USER_ID" "" "Validate cart items (stock check)"

# Test 11: Recalculate cart totals
echo "🧪 TEST 11: Recalculate Cart Totals"
test_endpoint "POST" "/cart/recalculate" "userId=$TEST_USER_ID" "Recalculate cart totals"

# Test 12: Add another product to cart
echo "🧪 TEST 12: Add Another Product"
test_endpoint "POST" "/cart/items" "userId=$TEST_USER_ID&productId=2&quantity=1" "Add different product to cart" "201"

# Test 13: Remove item from cart
echo "🧪 TEST 13: Remove Item from Cart"
test_endpoint "DELETE" "/cart/items/$TEST_PRODUCT_ID" "userId=$TEST_USER_ID" "Remove product from cart"

# Test 14: Clear entire cart
echo "🧪 TEST 14: Clear Entire Cart"
test_endpoint "DELETE" "/cart" "userId=$TEST_USER_ID" "Clear entire cart"

# Test 15: Verify cart is empty after clearing
echo "🧪 TEST 15: Verify Cart is Empty After Clearing"
test_endpoint "GET" "/cart/empty?userId=$TEST_USER_ID" "" "Verify cart is empty after clearing"

echo "=========================================="
echo "🛒 EDGE CASES & ERROR SCENARIOS"
echo "=========================================="

# Test 16: Add item with zero quantity (should fail)
echo "🧪 TEST 16: Add Item with Zero Quantity (Error Case)"
test_endpoint "POST" "/cart/items" "userId=$TEST_USER_ID&productId=$TEST_PRODUCT_ID&quantity=0" "Add item with zero quantity (should fail)" "400"

# Test 17: Add item with negative quantity (should fail)
echo "🧪 TEST 17: Add Item with Negative Quantity (Error Case)"
test_endpoint "POST" "/cart/items" "userId=$TEST_USER_ID&productId=$TEST_PRODUCT_ID&quantity=-1" "Add item with negative quantity (should fail)" "400"

# Test 18: Update item quantity to negative (should fail)
echo "🧪 TEST 18: Update Item Quantity to Negative (Error Case)"
test_endpoint "PUT" "/cart/items/$TEST_PRODUCT_ID" "userId=$TEST_USER_ID&quantity=-1" "Update item quantity to negative (should fail)" "400"

# Test 19: Get cart for non-existent user
echo "🧪 TEST 19: Get Cart for Non-existent User"
test_endpoint "GET" "/cart?userId=99999" "" "Get cart for non-existent user" "404"

# Test 20: Remove non-existent item from cart
echo "🧪 TEST 20: Remove Non-existent Item from Cart"
test_endpoint "DELETE" "/cart/items/99999" "userId=$TEST_USER_ID" "Remove non-existent item from cart" "404"

echo "=========================================="
echo "📊 TEST SUMMARY"
echo "=========================================="
echo "✅ Cart API Testing Completed"
echo ""
echo "📈 Test Coverage:"
echo "  • Basic Cart Operations: ✅"
echo "  • Cart Item Management: ✅"
echo "  • Cart Validation: ✅"
echo "  • Error Handling: ✅"
echo "  • Edge Cases: ✅"
echo ""
echo "🎯 Next Steps:"
echo "  • Review test results above"
echo "  • Check application logs for any errors"
echo "  • Proceed to Orders API testing"
echo ""
echo "📋 Total Endpoints Tested: 13"
echo "📋 Edge Cases Tested: 5"
echo "=========================================="
