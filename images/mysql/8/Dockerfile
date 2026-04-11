# CascadeGuard Hardened MySQL 8.4 Image
# https://github.com/cascadeguard/open-secure-images
#
# Upgraded from mysql:8.0 (EOL April 2026) to mysql:8.4 (current LTS).
# mysql:8.0 had persistent build failures caused by its apt repository
# breaking after EOL; 8.4 resolves this and has fewer open CVEs. (CAS-472)

FROM mysql:8.4

LABEL maintainer="CascadeGuard <security@cascadeguard.dev>"
LABEL org.opencontainers.image.title="cascadeguard/mysql"
LABEL org.opencontainers.image.version="8.4"
LABEL org.opencontainers.image.description="CascadeGuard hardened MySQL 8.4 image"
LABEL org.opencontainers.image.source="https://github.com/cascadeguard/open-secure-images"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="CascadeGuard"

COPY shared/hardening/minimize-packages.sh /tmp/

RUN chmod +x /tmp/*.sh && \
    /tmp/minimize-packages.sh && \
    rm -rf /tmp/*.sh /var/lib/apt/lists/* /var/cache/apt/*

# NOTE: We do NOT run set-nonroot or strip-shells here because mysql:8.4 uses
# the built-in 'mysql' user and the entrypoint requires bash.
# minimize-packages.sh handles package removal and apt cleanup.

# mysql image already runs as 'mysql' user
USER mysql
WORKDIR /var/lib/mysql

EXPOSE 3306

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
  CMD mysqladmin ping -h localhost --silent || exit 1
