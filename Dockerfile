FROM caddy:2-alpine

# Copy production-ready configurations
COPY Caddyfile.railway /etc/caddy/Caddyfile.railway
COPY Caddyfile /etc/caddy/Caddyfile.production

# Use Railway config by default (optimized for Railway platform)
COPY Caddyfile.railway /etc/caddy/Caddyfile

# Copy and setup entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

# Use entrypoint for dynamic password hash generation
ENTRYPOINT ["/entrypoint.sh"]