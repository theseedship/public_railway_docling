FROM caddy:2.10.0-alpine

# Security: Use non-root user (caddy user is already created in base image)
USER caddy

# Copy configuration with proper ownership
COPY --chown=caddy:caddy Caddyfile /etc/caddy/Caddyfile

# Health check for Railway deployments
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Use exec form to ensure proper signal handling
ENTRYPOINT ["caddy"]
CMD ["run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]