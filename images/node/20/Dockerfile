# CascadeGuard Hardened Node.js 20 Base Image
# https://github.com/cascadeguard/open-secure-images

FROM node:20-slim AS build

LABEL maintainer="CascadeGuard <security@cascadeguard.dev>"
LABEL org.opencontainers.image.title="cascadeguard/node"
LABEL org.opencontainers.image.version="20-slim"
LABEL org.opencontainers.image.description="CascadeGuard hardened Node.js 20 base image"
LABEL org.opencontainers.image.source="https://github.com/cascadeguard/open-secure-images"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="CascadeGuard"

COPY shared/hardening/minimize-packages.sh /tmp/
COPY shared/hardening/strip-shells.sh /tmp/
COPY shared/hardening/set-nonroot.sh /tmp/

RUN chmod +x /tmp/*.sh && \
    /tmp/minimize-packages.sh && \
    /tmp/set-nonroot.sh && \
    /tmp/strip-shells.sh && \
    rm -rf /tmp/*.sh /var/lib/apt/lists/* /var/cache/apt/*

# Remove npm cache and unnecessary node tooling
RUN npm cache clean --force 2>/dev/null || true && \
    rm -rf /root/.npm /root/.node-gyp /tmp/npm-* && \
    # Remove corepack — not needed in production base images
    rm -f /usr/local/bin/corepack || true

# Set secure filesystem permissions on node binaries
RUN chmod 755 /usr/local/bin/node && \
    chmod 755 /usr/local/bin/npm && \
    find /usr/local/lib/node_modules -type d -exec chmod 755 {} + && \
    find /usr/local/lib/node_modules -type f -exec chmod 644 {} +

USER nonroot
WORKDIR /app

HEALTHCHECK NONE

ENTRYPOINT ["node"]
CMD ["--version"]
