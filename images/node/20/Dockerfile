# CascadeGuard Hardened Node.js 20 Base Image
# https://github.com/cascadeguard/open-secure-images

# Pinned to digest for reproducibility (node:20-slim, last pushed 2026-03-25).
# Update this digest when upstream releases a new node:20-slim with security fixes.
FROM node:20-slim@sha256:1e85773c98c31d4fe5b545e4cb17379e617b348832fb3738b22a08f68dec30f3 AS build

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

# Upgrade npm to latest to patch HIGH-severity tar CVEs bundled in npm:
# GHSA-83g3-92jg-28cx, CVE-2026-26960, GHSA-qffp-2rhf-9h96, GHSA-9ppj-qmqm-q256,
# CVE-2026-29786, CVE-2026-31802, CVE-2026-23745, CVE-2026-23950.
# The node:20-slim base ships npm with a vulnerable tar; upgrading npm replaces
# the bundled tar at /usr/local/lib/node_modules/npm/node_modules/tar.
RUN npm install -g npm@latest

# Remove npm cache and unnecessary node tooling
RUN npm cache clean --force 2>/dev/null || true && \
    rm -rf /root/.npm /root/.node-gyp /tmp/npm-* && \
    # Remove corepack — not needed in production base images
    rm -f /usr/local/bin/corepack || true

# Set secure filesystem permissions on node binaries.
# Apply chmod 644 to all node_module files first, then re-apply 755 to
# executables — the broad 644 would otherwise strip the execute bit from
# npm's bin script (which /usr/local/bin/npm symlinks into node_modules).
RUN find /usr/local/lib/node_modules -type d -exec chmod 755 {} + && \
    find /usr/local/lib/node_modules -type f -exec chmod 644 {} + && \
    chmod 755 /usr/local/bin/node && \
    chmod 755 /usr/local/bin/npm && \
    find /usr/local/lib/node_modules/npm/bin -type f -exec chmod 755 {} +

USER nonroot
WORKDIR /app

HEALTHCHECK NONE

ENTRYPOINT ["node"]
CMD ["--version"]
