#!/bin/bash

# Railway Docling Template - Deployment Validation Script
# This script validates that your deployment is properly configured and secure

set -e

# Configuration
BASE_URL="${BASE_URL:-http://localhost:8080}"
API_TOKEN="${CADDY_AUTHORIZATION:-}"
BASIC_USER="${CADDY_USERNAME:-admin}"
BASIC_PASS="${BASIC_PASSWORD:-}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test results
TESTS_PASSED=0
TESTS_FAILED=0
WARNINGS=0

# Function to print colored output
print_color() {
    color=$1
    message=$2
    echo -e "${color}${message}${NC}"
}

# Function to print test result
print_test_result() {
    test_name=$1
    result=$2
    message=$3
    
    if [ "$result" = "PASS" ]; then
        print_color "$GREEN" "✅ $test_name: PASSED"
        ((TESTS_PASSED++))
    elif [ "$result" = "FAIL" ]; then
        print_color "$RED" "❌ $test_name: FAILED - $message"
        ((TESTS_FAILED++))
    elif [ "$result" = "WARN" ]; then
        print_color "$YELLOW" "⚠️  $test_name: WARNING - $message"
        ((WARNINGS++))
    fi
}

# Function to check if service is reachable
check_service_reachable() {
    print_color "$BLUE" "\n1. Checking service availability..."
    
    if curl -s -f -o /dev/null "$BASE_URL/health"; then
        print_test_result "Service Reachable" "PASS"
    else
        print_test_result "Service Reachable" "FAIL" "Cannot reach $BASE_URL/health"
        print_color "$RED" "\nService is not reachable. Please check:"
        echo "  - Is the service running?"
        echo "  - Is the URL correct? (Current: $BASE_URL)"
        echo "  - Are there any firewall issues?"
        exit 1
    fi
}

# Function to test health endpoint
test_health_endpoint() {
    print_color "$BLUE" "\n2. Testing health endpoints..."
    
    # Test /health endpoint
    response=$(curl -s -w "\n%{http_code}" "$BASE_URL/health")
    http_code=$(echo "$response" | tail -n1)
    
    if [ "$http_code" = "200" ]; then
        print_test_result "Health Endpoint" "PASS"
    else
        print_test_result "Health Endpoint" "FAIL" "HTTP $http_code"
    fi
    
    # Test /ready endpoint
    response=$(curl -s -w "\n%{http_code}" "$BASE_URL/ready")
    http_code=$(echo "$response" | tail -n1)
    
    if [ "$http_code" = "200" ]; then
        print_test_result "Ready Endpoint" "PASS"
    else
        print_test_result "Ready Endpoint" "WARN" "Backend might not be ready (HTTP $http_code)"
    fi
}

# Function to test security headers
test_security_headers() {
    print_color "$BLUE" "\n3. Testing security headers..."
    
    headers=$(curl -s -I "$BASE_URL/health")
    
    # Check for important security headers
    security_headers=(
        "Strict-Transport-Security"
        "X-Frame-Options"
        "X-Content-Type-Options"
        "Content-Security-Policy"
        "Referrer-Policy"
    )
    
    for header in "${security_headers[@]}"; do
        if echo "$headers" | grep -qi "$header"; then
            print_test_result "Header: $header" "PASS"
        else
            print_test_result "Header: $header" "FAIL" "Missing security header"
        fi
    done
    
    # Check that Server header is removed or customized
    if echo "$headers" | grep -qi "Server: Caddy"; then
        print_test_result "Server Header Hidden" "WARN" "Default server header exposed"
    else
        print_test_result "Server Header Hidden" "PASS"
    fi
}

# Function to test authentication
test_authentication() {
    print_color "$BLUE" "\n4. Testing authentication..."
    
    # Test API endpoint without auth (should fail)
    response=$(curl -s -w "\n%{http_code}" "$BASE_URL/v1/test" 2>/dev/null)
    http_code=$(echo "$response" | tail -n1)
    
    if [ "$http_code" = "401" ]; then
        print_test_result "API Auth Required" "PASS"
    else
        print_test_result "API Auth Required" "FAIL" "API accessible without auth (HTTP $http_code)"
    fi
    
    # Test API endpoint with auth (if token provided)
    if [ -n "$API_TOKEN" ]; then
        response=$(curl -s -w "\n%{http_code}" -H "Authorization: Bearer $API_TOKEN" "$BASE_URL/v1/test" 2>/dev/null)
        http_code=$(echo "$response" | tail -n1)
        
        # 404 is OK here as the endpoint might not exist, but auth passed
        if [ "$http_code" = "404" ] || [ "$http_code" = "200" ]; then
            print_test_result "API Bearer Auth" "PASS"
        else
            print_test_result "API Bearer Auth" "WARN" "Unexpected response (HTTP $http_code)"
        fi
    else
        print_test_result "API Bearer Auth" "WARN" "No API token provided for testing"
    fi
    
    # Test Basic Auth endpoint
    response=$(curl -s -w "\n%{http_code}" "$BASE_URL/ui" 2>/dev/null)
    http_code=$(echo "$response" | tail -n1)
    
    if [ "$http_code" = "401" ]; then
        print_test_result "Basic Auth Required" "PASS"
    else
        print_test_result "Basic Auth Required" "FAIL" "UI accessible without auth (HTTP $http_code)"
    fi
}

# Function to test rate limiting
test_rate_limiting() {
    print_color "$BLUE" "\n5. Testing rate limiting..."
    
    # Send multiple requests quickly to test rate limiting
    print_color "$YELLOW" "Sending burst requests to test rate limiting..."
    
    rate_limited=false
    for i in {1..20}; do
        response=$(curl -s -w "\n%{http_code}" "$BASE_URL/health" 2>/dev/null)
        http_code=$(echo "$response" | tail -n1)
        
        if [ "$http_code" = "429" ]; then
            rate_limited=true
            break
        fi
    done
    
    if [ "$rate_limited" = true ]; then
        print_test_result "Rate Limiting" "PASS"
    else
        print_test_result "Rate Limiting" "WARN" "Rate limiting might not be working or limits are high"
    fi
}

# Function to test CORS (if configured)
test_cors() {
    print_color "$BLUE" "\n6. Testing CORS configuration..."
    
    # Test preflight request
    response=$(curl -s -X OPTIONS -H "Origin: https://example.com" \
        -H "Access-Control-Request-Method: POST" \
        -H "Access-Control-Request-Headers: Content-Type" \
        -I "$BASE_URL/v1/test" 2>/dev/null)
    
    if echo "$response" | grep -qi "Access-Control-Allow-Origin"; then
        print_test_result "CORS Headers" "WARN" "CORS is enabled - verify allowed origins"
    else
        print_test_result "CORS Headers" "PASS" "CORS not enabled (good for security)"
    fi
}

# Function to test documentation endpoints
test_documentation() {
    print_color "$BLUE" "\n7. Testing documentation endpoints..."
    
    # Test OpenAPI endpoint
    response=$(curl -s -w "\n%{http_code}" "$BASE_URL/openapi.json" 2>/dev/null)
    http_code=$(echo "$response" | tail -n1)
    
    if [ "$http_code" = "200" ] || [ "$http_code" = "404" ]; then
        if [ "$http_code" = "200" ]; then
            print_test_result "OpenAPI Docs" "PASS"
        else
            print_test_result "OpenAPI Docs" "WARN" "Documentation not available"
        fi
    else
        print_test_result "OpenAPI Docs" "FAIL" "Unexpected response (HTTP $http_code)"
    fi
}

# Function to test SSL/TLS (if HTTPS)
test_ssl() {
    if [[ "$BASE_URL" == https://* ]]; then
        print_color "$BLUE" "\n8. Testing SSL/TLS configuration..."
        
        # Test SSL certificate
        if curl -s -f -o /dev/null "$BASE_URL/health"; then
            print_test_result "SSL Certificate" "PASS"
        else
            print_test_result "SSL Certificate" "FAIL" "SSL certificate issue"
        fi
        
        # Test HSTS header
        headers=$(curl -s -I "$BASE_URL/health")
        if echo "$headers" | grep -qi "Strict-Transport-Security"; then
            print_test_result "HSTS Enabled" "PASS"
        else
            print_test_result "HSTS Enabled" "FAIL" "HSTS not configured"
        fi
    fi
}

# Function to generate summary report
generate_summary() {
    print_color "$BLUE" "\n========================================="
    print_color "$BLUE" "VALIDATION SUMMARY"
    print_color "$BLUE" "========================================="
    
    total_tests=$((TESTS_PASSED + TESTS_FAILED))
    
    echo
    print_color "$GREEN" "Tests Passed: $TESTS_PASSED"
    print_color "$RED" "Tests Failed: $TESTS_FAILED"
    print_color "$YELLOW" "Warnings: $WARNINGS"
    echo
    
    if [ $TESTS_FAILED -eq 0 ]; then
        print_color "$GREEN" "🎉 All critical tests passed! Your deployment is properly configured."
    else
        print_color "$RED" "⚠️  Some tests failed. Please review and fix the issues above."
    fi
    
    if [ $WARNINGS -gt 0 ]; then
        print_color "$YELLOW" "📝 There are $WARNINGS warnings that you should review."
    fi
    
    # Security recommendations
    print_color "$BLUE" "\n========================================="
    print_color "$BLUE" "SECURITY RECOMMENDATIONS"
    print_color "$BLUE" "========================================="
    echo
    echo "1. ✅ Regularly rotate API tokens and passwords"
    echo "2. ✅ Monitor authentication logs for suspicious activity"
    echo "3. ✅ Keep Caddy and Docling updated with security patches"
    echo "4. ✅ Use Railway's private networking for internal services"
    echo "5. ✅ Enable audit logging in production"
    echo "6. ✅ Set up alerts for rate limit violations"
    echo "7. ✅ Review and adjust rate limits based on usage patterns"
    echo "8. ✅ Implement IP allowlisting for sensitive endpoints"
    
    print_color "$BLUE" "========================================="
}

# Main function
main() {
    clear
    print_color "$GREEN" "========================================="
    print_color "$GREEN" "Railway Docling - Deployment Validator"
    print_color "$GREEN" "========================================="
    echo
    print_color "$YELLOW" "Testing deployment at: $BASE_URL"
    echo
    
    # Check if we can reach the service first
    check_service_reachable
    
    # Run all tests
    test_health_endpoint
    test_security_headers
    test_authentication
    test_rate_limiting
    test_cors
    test_documentation
    test_ssl
    
    # Generate summary
    generate_summary
    
    # Exit with appropriate code
    if [ $TESTS_FAILED -gt 0 ]; then
        exit 1
    else
        exit 0
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --url)
            BASE_URL="$2"
            shift 2
            ;;
        --token)
            API_TOKEN="$2"
            shift 2
            ;;
        --username)
            BASIC_USER="$2"
            shift 2
            ;;
        --password)
            BASIC_PASS="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo
            echo "Options:"
            echo "  --url URL          Base URL of the deployment (default: http://localhost:8080)"
            echo "  --token TOKEN      API Bearer token for testing authenticated endpoints"
            echo "  --username USER    Basic auth username (default: admin)"
            echo "  --password PASS    Basic auth password for testing"
            echo "  --help            Show this help message"
            echo
            echo "Environment variables:"
            echo "  BASE_URL              Base URL of the deployment"
            echo "  CADDY_AUTHORIZATION   API Bearer token"
            echo "  CADDY_USERNAME        Basic auth username"
            echo "  BASIC_PASSWORD        Basic auth password"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Run main function
main