FROM caddy:2-alpine

# Copy all Caddyfile variants
COPY Caddyfile.minimal /etc/caddy/Caddyfile.minimal
COPY Caddyfile.standalone /etc/caddy/Caddyfile.standalone
COPY Caddyfile.railway /etc/caddy/Caddyfile.railway
COPY Caddyfile /etc/caddy/Caddyfile.full

# Use Railway config by default (connects to docling-serve)
COPY Caddyfile.railway /etc/caddy/Caddyfile

EXPOSE 8080

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]