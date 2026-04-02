# CascadeGuard Hardened Nginx Base Image
# https://github.com/cascadeguard/open-secure-images

FROM nginx:stable-alpine-slim AS build

LABEL maintainer="CascadeGuard <security@cascadeguard.dev>"
LABEL org.opencontainers.image.title="cascadeguard/nginx"
LABEL org.opencontainers.image.version="stable-alpine-slim"
LABEL org.opencontainers.image.description="CascadeGuard hardened Nginx base image"
LABEL org.opencontainers.image.source="https://github.com/cascadeguard/open-secure-images"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="CascadeGuard"

COPY shared/hardening/minimize-packages.sh /tmp/
COPY shared/hardening/strip-shells.sh /tmp/
COPY shared/hardening/set-nonroot.sh /tmp/

RUN chmod +x /tmp/*.sh && \
    /tmp/minimize-packages.sh && \
    /tmp/strip-shells.sh && \
    /tmp/set-nonroot.sh && \
    rm -rf /tmp/*.sh

# Configure nginx to run as non-root
RUN sed -i 's/listen\s*80;/listen 8080;/g' /etc/nginx/conf.d/default.conf && \
    sed -i '/^user /d' /etc/nginx/nginx.conf && \
    # Create required directories with correct ownership
    mkdir -p /var/cache/nginx/client_temp \
             /var/cache/nginx/proxy_temp \
             /var/cache/nginx/fastcgi_temp \
             /var/cache/nginx/uwsgi_temp \
             /var/cache/nginx/scgi_temp \
             /var/run && \
    chown -R nonroot:nonroot /var/cache/nginx /var/run /var/log/nginx && \
    chmod -R 755 /var/cache/nginx && \
    # Write pid to a location writable by nonroot
    sed -i 's|/var/run/nginx.pid|/var/run/nginx.pid|' /etc/nginx/nginx.conf && \
    chmod 755 /var/run

# Remove default HTML and replace with a minimal index
RUN rm -rf /usr/share/nginx/html/* && \
    echo '<!DOCTYPE html><html><head><title>CascadeGuard</title></head><body><p>Serving securely.</p></body></html>' \
      > /usr/share/nginx/html/index.html && \
    chown nonroot:nonroot /usr/share/nginx/html/index.html

EXPOSE 8080

USER nonroot
WORKDIR /usr/share/nginx/html

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:8080/ || exit 1

ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
