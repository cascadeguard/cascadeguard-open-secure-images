# cascadeguard/alpine

Hardened Alpine 3.20 base image, maintained by [CascadeGuard](https://cascadeguard.dev).

## What this image is

A minimal, security-hardened version of `alpine:3.20` with unnecessary tools removed, SUID bits stripped, and all processes running as a non-root user by default.

## Hardening applied

- Non-root user (`nonroot`, UID 65532) set by default
- SUID/SGID bits stripped from all binaries
- `wget` removed (busybox applet deleted)
- World-writable directory permissions removed (except `/tmp`)
- Unnecessary system accounts (`games`, `ftp`, `news`, `lp`) removed
- All packages upgraded to latest patched versions at build time

## Usage

```dockerfile
FROM cascadeguard/alpine:3.20

# Your application setup here
COPY --chown=nonroot:nonroot app /app
CMD ["/app/server"]
```

## Tags

| Tag | Description |
|-----|-------------|
| `3.20` | Alpine 3.20 LTS |
| `latest` | Latest build |

## Security features

Every image release includes:

- **Cosign signature** — cryptographic proof of build provenance
- **SBOM** — Software Bill of Materials in SPDX and CycloneDX formats, attached as OCI artifacts
- **Vulnerability scan** — Grype scan with zero critical/high CVE tolerance at build time
- **SLSA Level 3 provenance attestation** — via GitHub Actions

## Verify the image

```bash
# Verify Cosign signature
cosign verify cascadeguard/alpine:3.20 \
  --certificate-identity-regexp="https://github.com/cascadeguard/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com"
```

## Source

- GitHub: [cascadeguard/cascadeguard-open-secure-images](https://github.com/cascadeguard/cascadeguard-open-secure-images)
- License: [BSL 1.1 with image terms](https://github.com/cascadeguard/cascadeguard-open-secure-images/blob/main/LICENSE)
