# CascadeGuard Hardened Python 3.12 Base Image
# https://github.com/cascadeguard/open-secure-images

FROM python:3.12-slim@sha256:804ddf3251a60bbf9c92e73b7566c40428d54d0e79d3428194edf40da6521286 AS build

LABEL maintainer="CascadeGuard <security@cascadeguard.dev>"
LABEL org.opencontainers.image.title="cascadeguard/python"
LABEL org.opencontainers.image.version="3.12-slim"
LABEL org.opencontainers.image.description="CascadeGuard hardened Python 3.12 base image"
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

# Security hardening: remove packages and files not needed at runtime
# CVE-2025-69720: ncurses-bin contains infocmp with a stack buffer overflow.
#   The CLI tools (infocmp, tput, captoinfo) are not required in a Python runtime.
# CVE-2026-4046: iconv() can crash when converting IBM1390/IBM1399 character sets.
#   These mainframe encoding gconv modules are never needed in a Python container.
RUN if dpkg -l ncurses-bin 2>/dev/null | grep -q '^ii'; then \
      apt-get update && \
      apt-get purge -y ncurses-bin && \
      rm -rf /var/lib/apt/lists/* /var/cache/apt/*; \
    fi && \
    find /usr/lib \( -name 'IBM1390.so' -o -name 'IBM1399.so' \) -delete 2>/dev/null || true

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
