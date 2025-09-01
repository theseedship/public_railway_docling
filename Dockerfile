FROM caddy:2-alpine

# Copy production-ready configurations
COPY Caddyfile.railway /etc/caddy/Caddyfile.railway
COPY Caddyfile /etc/caddy/Caddyfile.production

# Use Railway config by default (optimized for Railway platform)
COPY Caddyfile.railway /etc/caddy/Caddyfile

EXPOSE 8080

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]