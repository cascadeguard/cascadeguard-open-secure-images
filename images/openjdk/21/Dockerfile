# CascadeGuard Hardened OpenJDK 21 Slim Image
# https://github.com/cascadeguard/open-secure-images

FROM openjdk:21-slim

LABEL maintainer="CascadeGuard <security@cascadeguard.dev>"
LABEL org.opencontainers.image.title="cascadeguard/openjdk"
LABEL org.opencontainers.image.version="21-slim"
LABEL org.opencontainers.image.description="CascadeGuard hardened OpenJDK 21 LTS slim image"
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

# Remove packages not needed at runtime
RUN apt-get update && \
    apt-get purge -y \
      wget \
      curl \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && find /usr/share/doc -maxdepth 1 -mindepth 1 -type d | xargs rm -rf \
    && rm -rf /usr/share/man

# Remove JDK tools not needed in a runtime-only image
# Keep java but strip javac, jshell, jar, jpackage, jlink from JDK if present
RUN for tool in javac jshell jar jlink jpackage; do \
      rm -f /usr/local/openjdk-21/bin/$tool 2>/dev/null || true; \
    done

USER nonroot
WORKDIR /app

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD java -version 2>&1 | grep -q "openjdk" || exit 1

CMD ["java", "-version"]
