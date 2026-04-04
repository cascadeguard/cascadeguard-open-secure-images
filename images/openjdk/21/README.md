# cascadeguard/openjdk

Hardened OpenJDK 21 LTS slim image, maintained by [CascadeGuard](https://cascadeguard.dev).

## What this image is

A security-hardened version of `openjdk:21-slim` with JDK compile-time tools stripped down to a runtime-only JRE, unnecessary packages removed, and all processes running as a non-root user by default.

## Hardening applied

- Non-root user (`nonroot`, UID 65532) set by default
- Shell utilities stripped (no bash, no sh)
- `wget` and `curl` removed
- JDK tools not needed at runtime removed: `javac`, `jshell`, `jar`, `jlink`, `jpackage`
- Man pages, documentation, and package caches purged
- Health check included (`java -version`)
- Exposes port 8080 (standard non-root JVM port)
- All packages upgraded to latest patched versions at build time

## Usage

```dockerfile
FROM cascadeguard/openjdk:21-slim

WORKDIR /app
COPY --chown=nonroot:nonroot target/app.jar .
CMD ["java", "-jar", "app.jar"]
```

With JVM tuning for containers:

```dockerfile
FROM cascadeguard/openjdk:21-slim

WORKDIR /app
COPY --chown=nonroot:nonroot target/app.jar .
CMD ["java", \
     "-XX:+UseContainerSupport", \
     "-XX:MaxRAMPercentage=75.0", \
     "-jar", "app.jar"]
```

## Tags

| Tag | Description |
|-----|-------------|
| `21-slim` | OpenJDK 21 LTS slim (runtime image) |
| `latest` | Latest build |

## Security features

Every image release includes:

- **Cosign signature** — cryptographic proof of build provenance
- **SBOM** — Software Bill of Materials in SPDX and CycloneDX formats, attached as OCI artifacts
- **Vulnerability scan** — Grype scan with zero critical/high CVE tolerance at build time
- **SLSA Level 3 provenance attestation** — via GitHub Actions

## Verify the image

```bash
cosign verify cascadeguard/openjdk:21-slim \
  --certificate-identity-regexp="https://github.com/cascadeguard/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com"
```

## Source

- GitHub: [cascadeguard/cascadeguard-open-secure-images](https://github.com/cascadeguard/cascadeguard-open-secure-images)
- License: [BSL 1.1 with image terms](https://github.com/cascadeguard/cascadeguard-open-secure-images/blob/main/LICENSE)
