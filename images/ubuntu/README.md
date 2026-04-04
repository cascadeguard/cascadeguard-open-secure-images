# cascadeguard/ubuntu

Hardened Ubuntu 22.04 LTS base image, maintained by [CascadeGuard](https://cascadeguard.dev).

## What this image is

A security-hardened version of `ubuntu:22.04` with unnecessary packages removed, world-writable permissions locked down, and all processes running as a non-root user by default.

## Hardening applied

- Non-root user (`nonroot`, UID 65532) set by default
- Shell utilities stripped
- `wget`, `curl`, `gnupg2`, and `apt-transport-https` removed
- Man pages, documentation, and package caches purged
- World-writable directory permissions removed (except `/proc`, `/sys`, `/dev`, `/tmp`, `/run`)
- All packages upgraded to latest patched versions at build time

## Usage

```dockerfile
FROM cascadeguard/ubuntu:22.04

WORKDIR /app
COPY --chown=nonroot:nonroot . .
CMD ["/app/server"]
```

## Tags

| Tag | Description |
|-----|-------------|
| `22.04` | Ubuntu 22.04 LTS (Jammy Jellyfish) |
| `latest` | Latest build |

## Security features

Every image release includes:

- **Cosign signature** — cryptographic proof of build provenance
- **SBOM** — Software Bill of Materials in SPDX and CycloneDX formats, attached as OCI artifacts
- **Vulnerability scan** — Grype scan with zero critical/high CVE tolerance at build time
- **SLSA Level 3 provenance attestation** — via GitHub Actions

## Verify the image

```bash
cosign verify cascadeguard/ubuntu:22.04 \
  --certificate-identity-regexp="https://github.com/cascadeguard/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com"
```

## Source

- GitHub: [cascadeguard/cascadeguard-open-secure-images](https://github.com/cascadeguard/cascadeguard-open-secure-images)
- License: [BSL 1.1 with image terms](https://github.com/cascadeguard/cascadeguard-open-secure-images/blob/main/LICENSE)
