#!/bin/bash

# Railway Docling Template - Password Hash Generator
# This script helps generate secure bcrypt password hashes for Basic Authentication

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    color=$1
    message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_color "$RED" "Error: Docker is not installed or not in PATH"
        print_color "$YELLOW" "Please install Docker from https://docs.docker.com/get-docker/"
        exit 1
    fi
}

# Function to generate random secure password
generate_random_password() {
    # Generate a secure random password (20 characters)
    if command -v openssl &> /dev/null; then
        openssl rand -base64 20 | tr -d "=+/" | cut -c1-20
    elif command -v uuidgen &> /dev/null; then
        uuidgen | tr -d '-' | cut -c1-20
    else
        # Fallback to /dev/urandom
        < /dev/urandom tr -dc 'A-Za-z0-9!@#$%^&*()_+' | head -c20
    fi
}

# Function to generate bcrypt hash
generate_hash() {
    local password=$1
    
    print_color "$BLUE" "\nGenerating bcrypt hash..."
    
    # Use Caddy's built-in hash-password command
    hash=$(echo "$password" | docker run -i --rm caddy:alpine caddy hash-password 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo "$hash"
    else
        print_color "$RED" "Error: Failed to generate hash"
        exit 1
    fi
}

# Function to generate secure API token
generate_api_token() {
    if command -v openssl &> /dev/null; then
        openssl rand -hex 32
    else
        # Fallback to /dev/urandom
        < /dev/urandom tr -dc 'a-f0-9' | head -c64
    fi
}

# Main script
main() {
    clear
    print_color "$GREEN" "========================================="
    print_color "$GREEN" "Railway Docling - Security Setup Wizard"
    print_color "$GREEN" "========================================="
    echo
    
    # Check Docker
    check_docker
    
    # Menu
    print_color "$YELLOW" "What would you like to generate?"
    echo "1) Basic Auth password hash (for CADDY_PASSWORD_HASH)"
    echo "2) API Bearer token (for CADDY_AUTHORIZATION)"
    echo "3) Both (complete security setup)"
    echo "4) Generate random password and hash"
    echo
    read -p "Select option (1-4): " option
    
    case $option in
        1)
            # Generate password hash
            echo
            read -s -p "Enter password for Basic Auth: " password
            echo
            read -s -p "Confirm password: " password_confirm
            echo
            
            if [ "$password" != "$password_confirm" ]; then
                print_color "$RED" "\nError: Passwords do not match"
                exit 1
            fi
            
            if [ -z "$password" ]; then
                print_color "$RED" "\nError: Password cannot be empty"
                exit 1
            fi
            
            hash=$(generate_hash "$password")
            
            print_color "$GREEN" "\n✅ Password hash generated successfully!"
            print_color "$YELLOW" "\nAdd this to your .env file or Railway environment variables:"
            echo "CADDY_PASSWORD_HASH=$hash"
            ;;
            
        2)
            # Generate API token
            token=$(generate_api_token)
            
            print_color "$GREEN" "\n✅ API token generated successfully!"
            print_color "$YELLOW" "\nAdd this to your .env file or Railway environment variables:"
            echo "CADDY_AUTHORIZATION=$token"
            ;;
            
        3)
            # Generate both
            echo
            read -s -p "Enter password for Basic Auth: " password
            echo
            read -s -p "Confirm password: " password_confirm
            echo
            
            if [ "$password" != "$password_confirm" ]; then
                print_color "$RED" "\nError: Passwords do not match"
                exit 1
            fi
            
            if [ -z "$password" ]; then
                print_color "$RED" "\nError: Password cannot be empty"
                exit 1
            fi
            
            hash=$(generate_hash "$password")
            token=$(generate_api_token)
            
            print_color "$GREEN" "\n✅ Security credentials generated successfully!"
            print_color "$YELLOW" "\nAdd these to your .env file or Railway environment variables:"
            echo
            echo "# Basic Auth credentials"
            echo "CADDY_USERNAME=admin"
            echo "CADDY_PASSWORD_HASH=$hash"
            echo
            echo "# API Bearer token"
            echo "CADDY_AUTHORIZATION=$token"
            ;;
            
        4)
            # Generate random password and hash
            password=$(generate_random_password)
            hash=$(generate_hash "$password")
            token=$(generate_api_token)
            
            print_color "$GREEN" "\n✅ Random credentials generated successfully!"
            print_color "$YELLOW" "\nSave these credentials securely (they won't be shown again):"
            echo
            print_color "$GREEN" "Basic Auth Credentials:"
            echo "Username: admin"
            echo "Password: $password"
            echo
            print_color "$GREEN" "Environment Variables:"
            echo "CADDY_USERNAME=admin"
            echo "CADDY_PASSWORD_HASH=$hash"
            echo "CADDY_AUTHORIZATION=$token"
            echo
            print_color "$RED" "⚠️  IMPORTANT: Save the password securely! The hash cannot be reversed."
            ;;
            
        *)
            print_color "$RED" "Invalid option"
            exit 1
            ;;
    esac
    
    echo
    print_color "$BLUE" "========================================="
    print_color "$BLUE" "Security Tips:"
    echo "• Use strong, unique passwords (min 12 characters)"
    echo "• Rotate API tokens regularly (monthly recommended)"
    echo "• Never commit credentials to version control"
    echo "• Use Railway's environment variables for production"
    echo "• Enable audit logging for authentication attempts"
    print_color "$BLUE" "========================================="
}

# Run main function
main