# CascadeGuard Hardened Python 3.12 Base Image
# https://github.com/cascadeguard/open-secure-images

FROM python:3.12-slim AS build

LABEL maintainer="CascadeGuard <security@cascadeguard.dev>"
LABEL org.opencontainers.image.title="cascadeguard/python"
LABEL org.opencontainers.image.version="3.12"
LABEL org.opencontainers.image.description="CascadeGuard hardened Python 3.12 base image"
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

# Remove pip cache and bytecode to reduce image size
RUN pip cache purge 2>/dev/null || true && \
    find /usr/local/lib/python3.12 -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true && \
    find /usr/local/lib/python3.12 -name '*.pyc' -delete 2>/dev/null || true

# Set secure filesystem permissions
RUN chmod 755 /usr/local/bin/python3.12 && \
    chmod 755 /usr/local/bin/pip && \
    find /usr/local/lib -type d -exec chmod 755 {} + && \
    find /usr/local/lib -type f -exec chmod 644 {} +

USER nonroot
WORKDIR /app

# Healthcheck support — override in derived images
HEALTHCHECK NONE

ENTRYPOINT ["python3"]
CMD ["--version"]
