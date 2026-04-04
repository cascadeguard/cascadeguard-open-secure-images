# cascadeguard/node

Hardened Node.js 20 LTS slim base image, maintained by [CascadeGuard](https://cascadeguard.dev).

## What this image is

A security-hardened version of `node:20-slim` with npm upgraded to patch bundled `tar` CVEs, unnecessary tooling removed, and all processes running as a non-root user by default.

## Hardening applied

- Non-root user (`nonroot`, UID 65532) set by default
- Shell utilities stripped (no bash, no sh)
- npm upgraded to latest to patch bundled `tar` CVEs (GHSA-83g3-92jg-28cx, CVE-2026-26960, and others)
- `corepack` removed (not needed in production base images)
- npm cache, `.node-gyp`, and tmp npm directories purged
- Secure filesystem permissions on node binaries and modules
- Base image pinned to a digest for reproducibility

## Usage

```dockerfile
FROM cascadeguard/node:20-slim

WORKDIR /app
COPY --chown=nonroot:nonroot package*.json ./
RUN npm ci --only=production
COPY --chown=nonroot:nonroot . .
CMD ["node", "server.js"]
```

## Tags

| Tag | Description |
|-----|-------------|
| `20-slim` | Node.js 20 LTS slim |
| `latest` | Latest build |

## Security features

Every image release includes:

- **Cosign signature** — cryptographic proof of build provenance
- **SBOM** — Software Bill of Materials in SPDX and CycloneDX formats, attached as OCI artifacts
- **Vulnerability scan** — Grype scan with zero critical/high CVE tolerance at build time
- **SLSA Level 3 provenance attestation** — via GitHub Actions

## Verify the image

```bash
cosign verify cascadeguard/node:20-slim \
  --certificate-identity-regexp="https://github.com/cascadeguard/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com"
```

## Source

- GitHub: [cascadeguard/cascadeguard-open-secure-images](https://github.com/cascadeguard/cascadeguard-open-secure-images)
- License: [BSL 1.1 with image terms](https://github.com/cascadeguard/cascadeguard-open-secure-images/blob/main/LICENSE)
