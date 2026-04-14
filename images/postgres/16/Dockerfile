# CascadeGuard Hardened PostgreSQL 16 Image
# https://github.com/cascadeguard/open-secure-images

FROM postgres:16@sha256:5a65324fe84dc41709ff914e90b07f3e2f577073ed27bf917d4873aca0c9ec51

LABEL maintainer="CascadeGuard <security@cascadeguard.dev>"
LABEL org.opencontainers.image.title="cascadeguard/postgres"
LABEL org.opencontainers.image.version="16"
LABEL org.opencontainers.image.description="CascadeGuard hardened PostgreSQL 16 image"
LABEL org.opencontainers.image.source="https://github.com/cascadeguard/open-secure-images"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="CascadeGuard"

COPY shared/hardening/minimize-packages.sh /tmp/

# minimize-packages.sh applies apt-get upgrade, removes unnecessary packages,
# runs apt-get autoremove, and strips /usr/share/doc and /usr/share/man.
# A second apt-get autoremove after minimize-packages.sh was found to
# cascade-remove packages needed by the structure tests (CAS-472).
RUN chmod +x /tmp/*.sh && \
    /tmp/minimize-packages.sh && \
    rm -rf /tmp/*.sh /var/lib/apt/lists/* /var/cache/apt/*

# NOTE: We do NOT run set-nonroot or strip-shells here because postgres:16 uses
# the built-in 'postgres' user (UID 999) and the entrypoint requires bash.
# The hardening is focused on removing unnecessary packages and documentation.

# The postgres image already runs as the 'postgres' user by default.
USER postgres
WORKDIR /var/lib/postgresql

EXPOSE 5432

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD pg_isready -U "${POSTGRES_USER:-postgres}" || exit 1
