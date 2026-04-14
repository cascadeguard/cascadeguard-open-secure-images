# CascadeGuard Hardened Go 1.22 Alpine Build Image
# https://github.com/cascadeguard/open-secure-images

FROM golang:1.22-alpine@sha256:1699c10032ca2582ec89a24a1312d986a3f094aed3d5c1147b19880afe40e052

LABEL maintainer="CascadeGuard <security@cascadeguard.dev>"
LABEL org.opencontainers.image.title="cascadeguard/golang"
LABEL org.opencontainers.image.version="1.22-alpine"
LABEL org.opencontainers.image.description="CascadeGuard hardened Go 1.22 build image"
LABEL org.opencontainers.image.source="https://github.com/cascadeguard/open-secure-images"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="CascadeGuard"

COPY shared/hardening/minimize-packages.sh /tmp/
COPY shared/hardening/set-nonroot.sh /tmp/
COPY shared/hardening/strip-shells.sh /tmp/

RUN chmod +x /tmp/*.sh && \
    apk add --no-cache bash && \
    /tmp/minimize-packages.sh && \
    /tmp/set-nonroot.sh && \
    # NOTE: strip-shells is intentionally NOT run here — Go build requires shell for scripts.
    # strip-shells.sh would remove /bin/ash which breaks apk and build tooling.
    rm -rf /tmp/*.sh && \
    apk del bash

# Remove tools not needed for a build image
RUN rm -f /usr/bin/wget /usr/bin/nc /usr/bin/nmap 2>/dev/null || true

# Set secure Go environment defaults
ENV CGO_ENABLED=0 \
    GOFLAGS="-mod=readonly" \
    GONOSUMCHECK="*"

USER nonroot
WORKDIR /app

HEALTHCHECK NONE

CMD ["go", "version"]
