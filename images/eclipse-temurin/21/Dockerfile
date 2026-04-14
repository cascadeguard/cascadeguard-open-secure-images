# CascadeGuard Hardened OpenJDK 21 Slim Image
# https://github.com/cascadeguard/open-secure-images
#
# Migrated from deprecated docker.io/library/openjdk:21-slim to Eclipse Temurin.
# The openjdk Docker Hub repository is EOL/unmaintained; Eclipse Temurin is the
# actively maintained successor published by the Eclipse Adoptium project.
# See: https://hub.docker.com/_/openjdk (deprecation notice)

FROM eclipse-temurin:21-jre-jammy@sha256:da196dd83cde2d23408db1ce69bfd4b64d6c4f5279f56dfe1ac55be32acca26d

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

# Remove JDK tools not needed in a runtime-only image.
# eclipse-temurin:21-jre-jammy is already a JRE image (no javac/jlink), but run
# defensively in case the base ever includes them. Temurin installs under /opt/java.
RUN for tool in javac jshell jar jlink jpackage; do \
      rm -f /opt/java/openjdk/bin/$tool 2>/dev/null || true; \
    done

USER nonroot
WORKDIR /app

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD java -version 2>&1 | grep -q "openjdk" || exit 1

CMD ["java", "-version"]
