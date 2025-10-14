#!/bin/bash

# Payments API Testing Script for E-commerce Application
# This script tests all 13 Payments API endpoints systematically

BASE_URL="http://localhost:8080/api"
TEST_USER_ID=1  # Using test user ID from database
TEST_ORDER_ID=4  # Using recent order ID from previous tests

echo "=========================================="
echo "💳 PAYMENTS API ENDPOINT TESTING"
echo "=========================================="
echo "Base URL: $BASE_URL"
echo "Test User ID: $TEST_USER_ID"
echo "Test Order ID: $TEST_ORDER_ID"
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
echo "💳 SETUP: Create Test Order for Payment Testing"
echo "=========================================="

# First, add items to cart and create an order for payment testing
echo "Setting up test order for payment testing..."
curl -s -X POST "$BASE_URL/cart/items" -d "userId=$TEST_USER_ID&productId=1&quantity=1" > /dev/null
curl -s -X POST "$BASE_URL/orders" -d "userId=$TEST_USER_ID&shippingAddress=Test+Payment+Address&orderNotes=Payment+test" > /dev/null

# Get the latest order ID for payment testing
LATEST_ORDER_ID=$(curl -s "$BASE_URL/orders/recent?userId=$TEST_USER_ID&limit=1" | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')

if [ ! -z "$LATEST_ORDER_ID" ]; then
    TEST_ORDER_ID=$LATEST_ORDER_ID
    echo "Using latest Order ID: $TEST_ORDER_ID for payment tests"
fi

echo "=========================================="
echo "📋 TEST EXECUTION STARTED"
echo "=========================================="

# Test 1: Process payment for order
echo "🧪 TEST 1: Process Payment for Order"
test_endpoint "POST" "/payments/process" "orderId=$TEST_ORDER_ID&paymentMethod=CREDIT_CARD" "Process payment for order" "201"

# Test 2: Process payment with different method
echo "🧪 TEST 2: Process Payment with UPI"
test_endpoint "POST" "/payments/process" "orderId=$TEST_ORDER_ID&paymentMethod=UPI" "Process UPI payment" "201"

# Get payment ID for further testing
PAYMENT_ID=$(curl -s "$BASE_URL/payments/order/$TEST_ORDER_ID" | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')

if [ ! -z "$PAYMENT_ID" ]; then
    echo "Using Payment ID: $PAYMENT_ID for further tests"

    # Test 3: Get payment by ID
    echo "🧪 TEST 3: Get Payment by ID"
    test_endpoint "GET" "/payments/$PAYMENT_ID" "" "Get payment by ID"

    # Test 4: Update payment status
    echo "🧪 TEST 4: Update Payment Status"
    test_endpoint "PUT" "/payments/$PAYMENT_ID/status" "status=COMPLETED" "Update payment status to COMPLETED"

    # Test 5: Mark payment as completed
    echo "🧪 TEST 5: Mark Payment as Completed"
    test_endpoint "PUT" "/payments/$PAYMENT_ID/complete" "" "Mark payment as completed"
fi

# Test 6: Get payment by order ID
echo "🧪 TEST 6: Get Payment by Order ID"
test_endpoint "GET" "/payments/order/$TEST_ORDER_ID" "" "Get payment by order ID"

# Test 7: Get payments by status
echo "🧪 TEST 7: Get Payments by Status"
test_endpoint "GET" "/payments/status/COMPLETED" "" "Get payments by COMPLETED status"

# Test 8: Get payments by method
echo "🧪 TEST 8: Get Payments by Method"
test_endpoint "GET" "/payments/method/CREDIT_CARD" "" "Get payments by CREDIT_CARD method"

# Test 9: Get payments by user ID
echo "🧪 TEST 9: Get Payments by User ID"
test_endpoint "GET" "/payments/user/$TEST_USER_ID" "" "Get payments by user ID"

# Test 10: Search payments
echo "🧪 TEST 10: Search Payments"
test_endpoint "GET" "/payments/search?searchTerm=payment" "" "Search payments"

# Test 11: Get payment statistics
echo "🧪 TEST 11: Get Payment Statistics"
test_endpoint "GET" "/payments/stats" "" "Get payment statistics"

# Test 12: Get all payments (admin function)
echo "🧪 TEST 12: Get All Payments"
test_endpoint "GET" "/payments" "" "Get all payments"

# Test 13: Mark payment as failed
if [ ! -z "$PAYMENT_ID" ]; then
    echo "🧪 TEST 13: Mark Payment as Failed"
    test_endpoint "PUT" "/payments/$PAYMENT_ID/fail" "reason=Test+failure" "Mark payment as failed"
fi

echo "=========================================="
echo "💳 EDGE CASES & ERROR SCENARIOS"
echo "=========================================="

# Test 14: Process payment for non-existent order
echo "🧪 TEST 14: Process Payment for Non-existent Order"
test_endpoint "POST" "/payments/process" "orderId=99999&paymentMethod=CREDIT_CARD" "Process payment for non-existent order" "404"

# Test 15: Get non-existent payment
echo "🧪 TEST 15: Get Non-existent Payment"
test_endpoint "GET" "/payments/99999" "" "Get non-existent payment" "404"

# Test 16: Update status of non-existent payment
echo "🧪 TEST 16: Update Status of Non-existent Payment"
test_endpoint "PUT" "/payments/99999/status" "status=COMPLETED" "Update status of non-existent payment" "404"

# Test 17: Process payment with invalid payment method
echo "🧪 TEST 17: Process Payment with Invalid Method"
test_endpoint "POST" "/payments/process" "orderId=$TEST_ORDER_ID&paymentMethod=INVALID_METHOD" "Process payment with invalid method" "400"

# Test 18: Get payment by transaction ID (if available)
echo "🧪 TEST 18: Get Payment by Transaction ID"
TRANSACTION_ID=$(curl -s "$BASE_URL/payments/order/$TEST_ORDER_ID" | grep -o '"transactionId":"[^"]*"' | head -1 | grep -o '"[^"]*"$' | tr -d '"')
if [ ! -z "$TRANSACTION_ID" ]; then
    test_endpoint "GET" "/payments/transaction/$TRANSACTION_ID" "" "Get payment by transaction ID"
fi

# Test 19: Test payment gateway integration
echo "🧪 TEST 19: Test Payment Gateway Integration"
test_endpoint "POST" "/payments/process" "orderId=$TEST_ORDER_ID&paymentMethod=NET_BANKING" "Test NET_BANKING payment method" "201"

# Test 20: Test payment validation
echo "🧪 TEST 20: Test Payment Validation"
# Try to process payment for already paid order
test_endpoint "POST" "/payments/process" "orderId=$TEST_ORDER_ID&paymentMethod=CREDIT_CARD" "Test payment for already processed order" "400"

echo "=========================================="
echo "📊 TEST SUMMARY"
echo "=========================================="
echo "✅ Payments API Testing Completed"
echo ""
echo "📈 Test Coverage:"
echo "  • Payment Processing: ✅"
echo "  • Payment Retrieval: ✅"
echo "  • Payment Status Management: ✅"
echo "  • Payment Search & Filtering: ✅"
echo "  • Payment Statistics: ✅"
echo "  • Error Handling: ✅"
echo "  • Edge Cases: ✅"
echo ""
echo "🎯 Next Steps:"
echo "  • Review test results above"
echo "  • Check application logs for any errors"
echo "  • Proceed to Users API testing"
echo ""
echo "📋 Total Endpoints Tested: 13"
echo "📋 Edge Cases Tested: 7"
echo "=========================================="
