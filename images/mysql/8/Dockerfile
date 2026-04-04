# CascadeGuard Hardened MySQL 8.0 Image
# https://github.com/cascadeguard/open-secure-images

FROM mysql:8.0

LABEL maintainer="CascadeGuard <security@cascadeguard.dev>"
LABEL org.opencontainers.image.title="cascadeguard/mysql"
LABEL org.opencontainers.image.version="8.0"
LABEL org.opencontainers.image.description="CascadeGuard hardened MySQL 8.0 image"
LABEL org.opencontainers.image.source="https://github.com/cascadeguard/open-secure-images"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="CascadeGuard"

COPY shared/hardening/minimize-packages.sh /tmp/

RUN chmod +x /tmp/*.sh && \
    /tmp/minimize-packages.sh && \
    rm -rf /tmp/*.sh /var/lib/apt/lists/* /var/cache/apt/*

# Remove packages not needed at runtime
RUN apt-get update && \
    apt-get purge -y \
      wget \
      gnupg \
      apt-transport-https \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && find /usr/share/doc -maxdepth 1 -mindepth 1 -type d | xargs rm -rf \
    && rm -rf /usr/share/man

# NOTE: We do NOT run set-nonroot or strip-shells here because mysql:8.0 uses
# the built-in 'mysql' user (UID 999) and the entrypoint requires bash.

# mysql image already runs as 'mysql' user
USER mysql
WORKDIR /var/lib/mysql

EXPOSE 3306

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
  CMD mysqladmin ping -h localhost --silent || exit 1
