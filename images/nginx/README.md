# cascadeguard/nginx

Hardened Nginx (stable-alpine-slim) base image, maintained by [CascadeGuard](https://cascadeguard.dev).

## What this image is

A security-hardened version of `nginx:stable-alpine-slim` configured to run as a non-root user on port 8080, with unnecessary tools removed and minimal attack surface.

## Hardening applied

- Non-root user (`nonroot`, UID 65532) — Nginx listens on **port 8080** instead of 80
- SUID/SGID bits stripped
- Shell utilities removed
- Default HTML replaced with a minimal static page
- Nginx worker process and cache directories owned by `nonroot`
- Health check included (HTTP GET to `localhost:8080`)

## Usage

```dockerfile
FROM cascadeguard/nginx:stable-alpine-slim

# Copy your static content
COPY --chown=nonroot:nonroot dist/ /usr/share/nginx/html/
```

Run the container:

```bash
docker run -p 8080:8080 cascadeguard/nginx:stable-alpine-slim
```

> **Note:** This image listens on port **8080**, not 80, because it runs as a non-root user. Update your ingress or reverse proxy accordingly.

## Tags

| Tag | Description |
|-----|-------------|
| `stable-alpine-slim` | Nginx stable on Alpine slim |
| `latest` | Latest build |

## Security features

Every image release includes:

- **Cosign signature** — cryptographic proof of build provenance
- **SBOM** — Software Bill of Materials in SPDX and CycloneDX formats, attached as OCI artifacts
- **Vulnerability scan** — Grype scan with zero critical/high CVE tolerance at build time
- **SLSA Level 3 provenance attestation** — via GitHub Actions

## Verify the image

```bash
cosign verify cascadeguard/nginx:stable-alpine-slim \
  --certificate-identity-regexp="https://github.com/cascadeguard/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com"
```

## Source

- GitHub: [cascadeguard/cascadeguard-open-secure-images](https://github.com/cascadeguard/cascadeguard-open-secure-images)
- License: [BSL 1.1 with image terms](https://github.com/cascadeguard/cascadeguard-open-secure-images/blob/main/LICENSE)
