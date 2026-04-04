# cascadeguard/golang

Hardened Go 1.22 Alpine build image, maintained by [CascadeGuard](https://cascadeguard.dev).

## What this image is

A security-hardened version of `golang:1.22-alpine` designed as a secure CI/CD build stage. Runs as a non-root user with secure Go environment defaults pre-configured.

## Hardening applied

- Non-root user (`nonroot`, UID 65532) set by default
- Unnecessary network tools removed (`wget`, `nc`, `nmap`)
- Minimal package set via `minimize-packages.sh`
- Secure Go environment defaults:
  - `CGO_ENABLED=0` — static binaries, no C dependencies
  - `GOFLAGS=-mod=readonly` — prevents unintentional go.sum modifications
  - `GONOSUMCHECK=*` — disables sum check for private modules
- All packages upgraded to latest patched versions at build time

> **Note:** Shell is preserved because Go build tooling requires it. This is a **build image**, not a runtime image — use a minimal base like `cascadeguard/alpine` for your final stage.

## Usage (multi-stage build)

```dockerfile
# Build stage
FROM cascadeguard/golang:1.22-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o /app/server ./cmd/server

# Runtime stage — minimal and non-root
FROM cascadeguard/alpine:3.20

COPY --from=builder --chown=nonroot:nonroot /app/server /app/server
CMD ["/app/server"]
```

## Tags

| Tag | Description |
|-----|-------------|
| `1.22-alpine` | Go 1.22 on Alpine |
| `latest` | Latest build |

## Security features

Every image release includes:

- **Cosign signature** — cryptographic proof of build provenance
- **SBOM** — Software Bill of Materials in SPDX and CycloneDX formats, attached as OCI artifacts
- **Vulnerability scan** — Grype scan with zero critical/high CVE tolerance at build time
- **SLSA Level 3 provenance attestation** — via GitHub Actions

## Verify the image

```bash
cosign verify cascadeguard/golang:1.22-alpine \
  --certificate-identity-regexp="https://github.com/cascadeguard/" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com"
```

## Source

- GitHub: [cascadeguard/cascadeguard-open-secure-images](https://github.com/cascadeguard/cascadeguard-open-secure-images)
- License: [BSL 1.1 with image terms](https://github.com/cascadeguard/cascadeguard-open-secure-images/blob/main/LICENSE)
