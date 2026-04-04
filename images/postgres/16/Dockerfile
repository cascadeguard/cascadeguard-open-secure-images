# CascadeGuard Hardened PostgreSQL 16 Image
# https://github.com/cascadeguard/open-secure-images

FROM postgres:16

LABEL maintainer="CascadeGuard <security@cascadeguard.dev>"
LABEL org.opencontainers.image.title="cascadeguard/postgres"
LABEL org.opencontainers.image.version="16"
LABEL org.opencontainers.image.description="CascadeGuard hardened PostgreSQL 16 image"
LABEL org.opencontainers.image.source="https://github.com/cascadeguard/open-secure-images"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="CascadeGuard"

COPY shared/hardening/minimize-packages.sh /tmp/

RUN chmod +x /tmp/*.sh && \
    /tmp/minimize-packages.sh && \
    rm -rf /tmp/*.sh /var/lib/apt/lists/* /var/cache/apt/*

# Remove packages not needed at runtime (postgres runs as the postgres user)
RUN apt-get update && \
    apt-get purge -y \
      wget \
      gnupg2 \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && find /usr/share/doc -maxdepth 1 -mindepth 1 -type d | xargs rm -rf \
    && rm -rf /usr/share/man

# NOTE: We do NOT run set-nonroot or strip-shells here because postgres:16 uses
# the built-in 'postgres' user (UID 999) and the entrypoint requires bash.
# The hardening is focused on removing unnecessary packages and documentation.

# The postgres image already runs as the 'postgres' user by default.
USER postgres
WORKDIR /var/lib/postgresql

EXPOSE 5432

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD pg_isready -U "${POSTGRES_USER:-postgres}" || exit 1
