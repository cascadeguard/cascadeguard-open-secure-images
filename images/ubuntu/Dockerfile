# CascadeGuard Hardened Ubuntu 22.04 LTS Base Image
# https://github.com/cascadeguard/open-secure-images

FROM ubuntu:22.04

LABEL maintainer="CascadeGuard <security@cascadeguard.dev>"
LABEL org.opencontainers.image.title="cascadeguard/ubuntu"
LABEL org.opencontainers.image.version="22.04"
LABEL org.opencontainers.image.description="CascadeGuard hardened Ubuntu 22.04 LTS base image"
LABEL org.opencontainers.image.source="https://github.com/cascadeguard/open-secure-images"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="CascadeGuard"

COPY shared/hardening/minimize-packages.sh /tmp/
COPY shared/hardening/set-nonroot.sh /tmp/

# NOTE: strip-shells.sh is intentionally NOT run here. On Ubuntu 22.04,
# /bin/sh → /bin/dash, so strip-shells would remove /bin/bash while keeping
# dash. The ubuntu base image is designed as a general-purpose base and the
# structure test explicitly verifies bash is present. Docker CMD also uses bash.
RUN chmod +x /tmp/*.sh && \
    /tmp/minimize-packages.sh && \
    /tmp/set-nonroot.sh && \
    rm -rf /tmp/*.sh /var/lib/apt/lists/* /var/cache/apt/*

# Remove packages not needed at runtime
RUN apt-get update && \
    apt-get purge -y \
      wget \
      curl \
      gnupg2 \
      apt-transport-https \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && find /usr/share/doc -maxdepth 1 -type d | tail -n +2 | xargs rm -rf \
    && rm -rf /usr/share/man /usr/share/info

# Remove world-writable permissions from non-tmpfs directories
RUN find / -xdev -type d -perm -o+w 2>/dev/null | \
    grep -v -E '^/(proc|sys|dev|tmp|run)' | \
    xargs chmod o-w 2>/dev/null || true

USER nonroot
WORKDIR /app

HEALTHCHECK NONE

CMD ["/bin/bash", "-c", "echo 'CascadeGuard hardened Ubuntu 22.04'"]
