# CascadeGuard Hardened Debian Slim Base Image
# https://github.com/cascadeguard/open-secure-images

FROM debian:bookworm-slim AS build

LABEL maintainer="CascadeGuard <security@cascadeguard.dev>"
LABEL org.opencontainers.image.title="cascadeguard/debian-slim"
LABEL org.opencontainers.image.version="bookworm"
LABEL org.opencontainers.image.description="CascadeGuard hardened Debian Bookworm Slim base image"
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
    rm -rf /tmp/*.sh /var/lib/apt/lists/* /var/cache/apt/*

# Debian-specific hardening
RUN apt-get update && apt-get upgrade -y && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* && \
    # Remove suid/sgid bits from non-essential binaries
    find / -perm /6000 -type f -exec chmod a-s {} + 2>/dev/null || true && \
    # Remove world-writable files (except /tmp)
    find / -xdev -type d -perm -0002 ! -path '/tmp' -exec chmod o-w {} + 2>/dev/null || true && \
    # Remove unnecessary system accounts
    sed -i '/^games:/d; /^lp:/d; /^news:/d; /^uucp:/d; /^proxy:/d; /^list:/d; /^irc:/d; /^gnats:/d' /etc/passwd && \
    sed -i '/^games:/d; /^lp:/d; /^news:/d; /^uucp:/d; /^proxy:/d; /^list:/d; /^irc:/d; /^gnats:/d' /etc/group

USER nonroot
WORKDIR /app

HEALTHCHECK NONE

CMD ["/bin/sh"]
