# CascadeGuard Hardened Redis 7 Alpine Image
# https://github.com/cascadeguard/open-secure-images

FROM redis:7.4-alpine@sha256:8b81dd37ff027bec4e516d41acfbe9fe2460070dc6d4a4570a2ac5b9d59df065

LABEL maintainer="CascadeGuard <security@cascadeguard.dev>"
LABEL org.opencontainers.image.title="cascadeguard/redis"
LABEL org.opencontainers.image.version="7.4-alpine"
LABEL org.opencontainers.image.description="CascadeGuard hardened Redis 7.4 image"
LABEL org.opencontainers.image.source="https://github.com/cascadeguard/open-secure-images"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="CascadeGuard"

COPY shared/hardening/minimize-packages.sh /tmp/
COPY shared/hardening/set-nonroot.sh /tmp/

RUN chmod +x /tmp/*.sh && \
    apk add --no-cache bash && \
    /tmp/minimize-packages.sh && \
    # Create nonroot user for our own reference but redis runs as 'redis' (UID 999)
    # The redis entrypoint uses the built-in redis user
    rm -rf /tmp/*.sh && \
    apk del bash

# Harden: remove shell utilities not needed at runtime
RUN rm -f /bin/ash /usr/bin/wget /usr/bin/curl 2>/dev/null || true

# Apply secure redis configuration defaults
RUN echo "protected-mode yes" >> /etc/redis.conf && \
    echo "loglevel notice" >> /etc/redis.conf && \
    echo "databases 16" >> /etc/redis.conf

# Redis runs as 'redis' user (UID 999) by default
USER redis
WORKDIR /data

EXPOSE 6379

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD redis-cli ping | grep -q PONG || exit 1
