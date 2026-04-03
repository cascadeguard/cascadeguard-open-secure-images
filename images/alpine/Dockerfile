# CascadeGuard Hardened Alpine Base Image
# https://github.com/cascadeguard/open-secure-images

FROM alpine:3.20 AS build

LABEL maintainer="CascadeGuard <security@cascadeguard.dev>"
LABEL org.opencontainers.image.title="cascadeguard/alpine"
LABEL org.opencontainers.image.version="3.20"
LABEL org.opencontainers.image.description="CascadeGuard hardened Alpine 3.20 base image"
LABEL org.opencontainers.image.source="https://github.com/cascadeguard/open-secure-images"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="CascadeGuard"

COPY shared/hardening/minimize-packages.sh /tmp/
COPY shared/hardening/strip-shells.sh /tmp/
COPY shared/hardening/set-nonroot.sh /tmp/

# Install bash temporarily so hardening scripts (#!/usr/bin/env bash) can run;
# strip-shells.sh removes /bin/bash before the image is finalised.
RUN apk add --no-cache bash && \
    chmod +x /tmp/*.sh && \
    /tmp/minimize-packages.sh && \
    /tmp/set-nonroot.sh && \
    /tmp/strip-shells.sh && \
    rm -rf /tmp/*.sh

# Alpine-specific hardening
RUN apk --no-cache upgrade && \
    # wget in Alpine 3.20 is a busybox applet — apk del silently no-ops.
    # Remove the binary directly to satisfy the no-wget security policy.
    rm -f /usr/bin/wget && \
    # Remove apk cache entirely
    rm -rf /var/cache/apk/* && \
    # Remove suid bits from all binaries
    find / -perm /6000 -type f -exec chmod a-s {} + 2>/dev/null || true && \
    # Remove world-writable directories (except /tmp)
    find / -xdev -type d -perm -0002 ! -path '/tmp' -exec chmod o-w {} + 2>/dev/null || true && \
    # Remove unnecessary accounts
    sed -i '/^games:/d; /^ftp:/d; /^news:/d; /^lp:/d' /etc/passwd && \
    sed -i '/^games:/d; /^ftp:/d; /^news:/d; /^lp:/d' /etc/group

USER nonroot
WORKDIR /app

HEALTHCHECK NONE

CMD ["/bin/sh"]
