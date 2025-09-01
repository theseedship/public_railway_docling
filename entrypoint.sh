#!/bin/sh
# Railway Docling Template - Dynamic Password Hash Generation
# This script handles password hashing at runtime for better security

set -e

echo "🚀 Railway Docling - Initializing security configuration..."

# Check and generate password hash if needed
if [ -n "$PASSWORD" ] && [ -z "$CADDY_PASSWORD_HASH" ]; then
    echo "🔐 Generating password hash from PASSWORD environment variable..."
    
    # Generate bcrypt hash using caddy hash-password
    CADDY_PASSWORD_HASH=$(echo "$PASSWORD" | caddy hash-password)
    export CADDY_PASSWORD_HASH
    
    echo "✅ Password hash generated successfully"
    echo "ℹ️  To change password: just update PASSWORD and redeploy"
    
elif [ -n "$CADDY_PASSWORD_HASH" ]; then
    # Hash exists, use it (even if PASSWORD is defined)
    echo "🔒 Using existing CADDY_PASSWORD_HASH"
    if [ -n "$PASSWORD" ]; then
        echo "ℹ️  Note: PASSWORD is set but ignored because CADDY_PASSWORD_HASH exists"
        echo "ℹ️  To use the new PASSWORD: remove CADDY_PASSWORD_HASH from Railway variables"
    fi
    
elif [ -n "$PASSWORD" ]; then
    # This case shouldn't normally happen, but handle it for safety
    echo "🔐 Generating password hash from PASSWORD..."
    CADDY_PASSWORD_HASH=$(echo "$PASSWORD" | caddy hash-password)
    export CADDY_PASSWORD_HASH
    echo "✅ Password hash generated"
    
else
    # Neither PASSWORD nor HASH is set
    echo "❌ ERROR: Authentication not configured!"
    echo "   Please set either:"
    echo "   - PASSWORD (recommended for new deployments)"
    echo "   - CADDY_PASSWORD_HASH (for existing deployments)"
    exit 1
fi

# Validate API token
if [ -z "$CADDY_AUTHORIZATION" ]; then
    echo "⚠️  WARNING: CADDY_AUTHORIZATION (API token) is not set!"
    echo "   API endpoints (/v1/*) will not be accessible"
    echo "   Set CADDY_AUTHORIZATION to a secure random token"
fi

# Show configuration summary (without sensitive data)
echo ""
echo "📋 Configuration Summary:"
echo "   Username: ${CADDY_USERNAME:-admin}"
echo "   Password: [CONFIGURED]"
echo "   API Token: ${CADDY_AUTHORIZATION:+[CONFIGURED]}"
echo "   IP Filter: ${ENABLE_IP_FILTER:-false}"
if [ "${ENABLE_IP_FILTER}" = "true" ]; then
    echo "   Allowed IPs: ${ALLOWED_IPS:-0.0.0.0/0}"
fi
echo ""

# Start Caddy with the configuration
echo "🎯 Starting Caddy server..."
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile