FROM caddy:2.10.0-alpine

# Note: The caddy user (UID 1001) already exists in the official caddy image
# No need to switch user as Caddy drops privileges automatically

# Copy both Caddyfiles
COPY --chown=1001:1001 Caddyfile.minimal /etc/caddy/Caddyfile.minimal
COPY --chown=1001:1001 Caddyfile /etc/caddy/Caddyfile.full

# Use minimal config by default
COPY --chown=1001:1001 Caddyfile.minimal /etc/caddy/Caddyfile

# Health check for Railway deployments
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Use exec form to ensure proper signal handling
ENTRYPOINT ["caddy"]
CMD ["run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]