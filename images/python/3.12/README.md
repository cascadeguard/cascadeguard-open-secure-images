# cascadeguard/python

Hardened Python 3.12 slim base image, maintained by [CascadeGuard](https://cascadeguard.dev).

## What this image is

A security-hardened version of `python:3.12-slim` with unnecessary packages removed, bytecode cache purged, and all processes running as a non-root user by default.

## Hardening applied

- Non-root user (`nonroot`, UID 65532) set by default
- Shell utilities stripped (no bash, no sh)
- `ncurses-bin` removed (patched CVE-2025-69720 — `infocmp` stack buffer overflow)
- IBM1390/IBM1399 mainframe gconv modules removed (patched CVE-2026-4046)
- pip cache and `.pyc` bytecode files purged
- Secure filesystem permissions on Python binaries and libraries
- All packages upgraded to latest patched versions at build time

## Usage

```dockerfile
FROM cascadeguard/python:3.12-slim

WORKDIR /app
COPY --chown=nonroot:nonroot requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY --chown=nonroot:nonroot . .
CMD ["python3", "main.py"]
```

## Tags

| Tag | Description |
|-----|-------------|
| `3.12-slim` | Python 3.12 slim |
| `latest` | Latest build |

## Security features

Every image release includes:

- **Cosign signature** — cryptographic proof of build provenance
- **SBOM** — Software Bill of Materials in SPDX and CycloneDX formats, attached as OCI artifacts
- **Vulnerability scan** — Grype scan with zero critical/high CVE tolerance at build time
- **SLSA Level 3 provenance attestation** — via GitHub Actions

## Verify the image

```bash
cosign verify cascadeguard/python:3.12-slim \
  --certificate-identity-regexp="https://github.com/cascadeguard/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com"
```

## Source

- GitHub: [cascadeguard/cascadeguard-open-secure-images](https://github.com/cascadeguard/cascadeguard-open-secure-images)
- License: [BSL 1.1 with image terms](https://github.com/cascadeguard/cascadeguard-open-secure-images/blob/main/LICENSE)
