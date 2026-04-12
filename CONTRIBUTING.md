# Contributing to cascadeguard-open-secure-images

Thank you for your interest in contributing to CascadeGuard's open secure images!

## Process

The full CascadeGuard SDLC — covering feature lifecycle, issue management, PR process, testing requirements, and the definition of done — lives in:

**[cascadeguard-docs/docs/sdlc.md](https://github.com/cascadeguard/cascadeguard-docs/blob/main/docs/sdlc.md)**

## Repo-Specific Setup

```bash
# Install Python dependencies for CI tooling
pip install -r requirements.txt

# Validate images.yaml schema
task validate

# Run a local Grype scan on a specific image
task scan IMAGE=nginx:stable-alpine
```

## Branch Naming

Use `<identifier>/<short-description>`:
- `CAS-42/fix-redis-cve`
- `feat/add-golang-image`

## What Lives Here

This repo manages the 25 CascadeGuard-maintained secure base images:

- `images.yaml` — canonical image catalog with metadata (tier, deprecation status, CVE count)
- `images/` — per-image Dockerfiles
- `shared/` — reusable CI workflows and scanning configuration
- `dockerhub-analysis.md` — Docker Hub analysis and field documentation

## Deprecation Fields

When contributing new images or updating existing ones, follow the schema defined in `dockerhub-analysis.md`:

- `deprecated: true/false` — set based on official Docker Hub deprecation notices only
- `recommended_replacement` — upstream-recommended replacement (only when `deprecated: true`)
- `weekly_downloads` — populated via automated sync; set to `null` for new entries

## Security

Report vulnerabilities via the [security policy](https://github.com/cascadeguard/cascadeguard/blob/main/SECURITY.md). Do not open public issues for security bugs.
