# 🔐 Authentication Setup Guide

## Current Problem
You're trying to login with the hash instead of the actual password!

## Solution

### Option 1: Use a Known Password (Recommended)

1. **Choose a password**, for example: `changeme123`

2. **Generate the hash**:
   ```bash
   echo "changeme123" | docker run -i --rm caddy:alpine caddy hash-password
   ```
   This gives you: `$2a$14$ie021zGE/khCb1XJ7MBhFuS1Gu132NY6KN/1YWXjyEOTUOdMDoCyC`

3. **Update Railway environment variables**:
   ```
   CADDY_USERNAME = admin
   CADDY_PASSWORD_HASH = $2a$14$ie021zGE/khCb1XJ7MBhFuS1Gu132NY6KN/1YWXjyEOTUOdMDoCyC
   ```

4. **Login with**:
   - Username: `admin`
   - Password: `changeme123` (NOT the hash!)

### Option 2: Find Your Current Password

Your current hash is: `$2a$14$Qo8ZmaWgYI13vGy19XItneUfTh0RdTCcyShWXstZijdja.t2OVyli`

This hash was generated from a specific password. Common possibilities:
- `admin`
- `password`
- `changeme`
- `docling`

Try these passwords with username `admin`.

### Option 3: Generate New Credentials

Run the password generation script:
```bash
./scripts/generate-password.sh
```

Choose option 4 to generate a random password and hash. It will show you:
- The actual password (save this!)
- The hash (put in CADDY_PASSWORD_HASH)

## How Basic Auth Works

```
Browser/Client                    Caddy                         Your Brain
     |                             |                                |
     |-- Request /ui ----------->  |                                |
     |                             |                                |
     |<-- 401 Need Auth ---------- |                                |
     |                             |                                |
     |-- Username: admin --------> |                                |
     |-- Password: changeme123 --> | <-- Hashes & compares with --> | CADDY_PASSWORD_HASH
     |                             |     stored hash                |
     |<-- 200 OK ----------------- |                                |
```

## Current Variables Setup

In Railway, you should have:
```env
# API Authentication (Bearer Token)
CADDY_AUTHORIZATION=b8115c529d48a28c46805be9dd0c4e34e755c644d68f59c05af20bb09a5123fe

# Basic Auth for UI
CADDY_USERNAME=admin
CADDY_PASSWORD_HASH=$2a$14$ie021zGE/khCb1XJ7MBhFuS1Gu132NY6KN/1YWXjyEOTUOdMDoCyC

# Port
PORT=8080
```

## Testing Authentication

```bash
# Your Railway URL
URL="https://publicrailwaydocling-production.up.railway.app"

# Test Basic Auth (use the actual password, not the hash!)
curl -u admin:changeme123 $URL/ui

# Test Bearer Auth (use the token as-is)
curl -H "Authorization: Bearer b8115c529d48a28c46805be9dd0c4e34e755c644d68f59c05af20bb09a5123fe" $URL/v1/health
```

## Important Notes

⚠️ **NEVER** use the hash as the password when logging in!
- ❌ Password: `$2a$14$Qo8ZmaWgYI13vGy19XItneUfTh0RdTCcyShWXstZijdja.t2OVyli`
- ✅ Password: `changeme123` (or whatever password you chose)

The hash is only for storage in the environment variable. The actual password is what you type in the browser.

## Quick Fix Steps

1. Go to Railway Dashboard
2. Update `CADDY_PASSWORD_HASH` to: `$2a$14$ie021zGE/khCb1XJ7MBhFuS1Gu132NY6KN/1YWXjyEOTUOdMDoCyC`
3. Wait for redeploy (1-2 minutes)
4. Login to `/ui` with:
   - Username: `admin`
   - Password: `changeme123`

Done! 🎉