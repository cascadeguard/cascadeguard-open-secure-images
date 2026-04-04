# cascadeguard/postgres

Hardened PostgreSQL 16 image, maintained by [CascadeGuard](https://cascadeguard.dev).

## What this image is

A security-hardened version of `postgres:16` with unnecessary packages removed and the built-in `postgres` user enforced. The hardening focuses on reducing attack surface while preserving full PostgreSQL functionality.

## Hardening applied

- Runs as the built-in `postgres` user (UID 999) — no root at runtime
- `wget` and `gnupg2` removed
- Man pages, documentation, and package caches purged
- Minimal package set via `minimize-packages.sh`
- Health check included (`pg_isready`) with 30s startup grace period
- All packages upgraded to latest patched versions at build time

> **Note:** Shell and bash are preserved because the PostgreSQL entrypoint requires them. Hardening focuses on package removal rather than shell stripping.

## Usage

```bash
docker run -d \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -p 5432:5432 \
  cascadeguard/postgres:16
```

```dockerfile
FROM cascadeguard/postgres:16

# Add custom init scripts
COPY --chown=postgres:postgres init.sql /docker-entrypoint-initdb.d/
```

## Tags

| Tag | Description |
|-----|-------------|
| `16` | PostgreSQL 16 |
| `latest` | Latest build |

## Security features

Every image release includes:

- **Cosign signature** — cryptographic proof of build provenance
- **SBOM** — Software Bill of Materials in SPDX and CycloneDX formats, attached as OCI artifacts
- **Vulnerability scan** — Grype scan with zero critical/high CVE tolerance at build time
- **SLSA Level 3 provenance attestation** — via GitHub Actions

## Verify the image

```bash
cosign verify cascadeguard/postgres:16 \
  --certificate-identity-regexp="https://github.com/cascadeguard/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com"
```

## Source

- GitHub: [cascadeguard/cascadeguard-open-secure-images](https://github.com/cascadeguard/cascadeguard-open-secure-images)
- License: [BSL 1.1 with image terms](https://github.com/cascadeguard/cascadeguard-open-secure-images/blob/main/LICENSE)
