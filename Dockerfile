FROM caddy:2-alpine

# Copy all Caddyfile variants
COPY Caddyfile.minimal /etc/caddy/Caddyfile.minimal
COPY Caddyfile.standalone /etc/caddy/Caddyfile.standalone
COPY Caddyfile /etc/caddy/Caddyfile.full

# Use standalone config by default (works without docling-serve)
COPY Caddyfile.standalone /etc/caddy/Caddyfile

EXPOSE 8080

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]