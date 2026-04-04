# cascadeguard/redis

Hardened Redis 7.4 Alpine image, maintained by [CascadeGuard](https://cascadeguard.dev).

## What this image is

A security-hardened version of `redis:7.4-alpine` with shell utilities removed, secure Redis configuration defaults applied, and the built-in `redis` user enforced.

## Hardening applied

- Runs as the built-in `redis` user (UID 999) — no root at runtime
- `/bin/ash`, `wget`, and `curl` removed
- Minimal package set via `minimize-packages.sh`
- Secure Redis config defaults: `protected-mode yes`, `loglevel notice`, `databases 16`
- Health check included (`redis-cli ping`) with 10s startup grace period
- All packages upgraded to latest patched versions at build time

## Usage

```bash
docker run -d -p 6379:6379 cascadeguard/redis:7.4-alpine
```

With a custom config:

```bash
docker run -d -p 6379:6379 \
  -v /path/to/redis.conf:/usr/local/etc/redis/redis.conf \
  cascadeguard/redis:7.4-alpine \
  redis-server /usr/local/etc/redis/redis.conf
```

## Tags

| Tag | Description |
|-----|-------------|
| `7.4-alpine` | Redis 7.4 on Alpine |
| `latest` | Latest build |

## Security features

Every image release includes:

- **Cosign signature** — cryptographic proof of build provenance
- **SBOM** — Software Bill of Materials in SPDX and CycloneDX formats, attached as OCI artifacts
- **Vulnerability scan** — Grype scan with zero critical/high CVE tolerance at build time
- **SLSA Level 3 provenance attestation** — via GitHub Actions

## Verify the image

```bash
cosign verify cascadeguard/redis:7.4-alpine \
  --certificate-identity-regexp="https://github.com/cascadeguard/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com"
```

## Source

- GitHub: [cascadeguard/cascadeguard-open-secure-images](https://github.com/cascadeguard/cascadeguard-open-secure-images)
- License: [BSL 1.1 with image terms](https://github.com/cascadeguard/cascadeguard-open-secure-images/blob/main/LICENSE)
