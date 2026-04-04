# cascadeguard/mysql

Hardened MySQL 8.0 image, maintained by [CascadeGuard](https://cascadeguard.dev).

## What this image is

A security-hardened version of `mysql:8.0` with unnecessary packages removed and the built-in `mysql` user enforced. The hardening focuses on reducing attack surface while preserving full MySQL functionality.

## Hardening applied

- Runs as the built-in `mysql` user (UID 999) — no root at runtime
- `wget`, `gnupg`, and `apt-transport-https` removed
- Man pages, documentation, and package caches purged
- Minimal package set via `minimize-packages.sh`
- Health check included (`mysqladmin ping`) with 60s startup grace period
- All packages upgraded to latest patched versions at build time

> **Note:** Shell and bash are preserved because the MySQL entrypoint requires them. Hardening focuses on package removal rather than shell stripping.

## Usage

```bash
docker run -d \
  -e MYSQL_ROOT_PASSWORD=mysecretpassword \
  -e MYSQL_DATABASE=mydb \
  -p 3306:3306 \
  cascadeguard/mysql:8.0
```

```dockerfile
FROM cascadeguard/mysql:8.0

# Add custom init scripts
COPY --chown=mysql:mysql init.sql /docker-entrypoint-initdb.d/
```

## Tags

| Tag | Description |
|-----|-------------|
| `8.0` | MySQL 8.0 |
| `latest` | Latest build |

## Security features

Every image release includes:

- **Cosign signature** — cryptographic proof of build provenance
- **SBOM** — Software Bill of Materials in SPDX and CycloneDX formats, attached as OCI artifacts
- **Vulnerability scan** — Grype scan with zero critical/high CVE tolerance at build time
- **SLSA Level 3 provenance attestation** — via GitHub Actions

## Verify the image

```bash
cosign verify cascadeguard/mysql:8.0 \
  --certificate-identity-regexp="https://github.com/cascadeguard/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com"
```

## Source

- GitHub: [cascadeguard/cascadeguard-open-secure-images](https://github.com/cascadeguard/cascadeguard-open-secure-images)
- License: [BSL 1.1 with image terms](https://github.com/cascadeguard/cascadeguard-open-secure-images/blob/main/LICENSE)
