# CascadeGuard Scan Report

- **Directory:** `/Users/craig/src/workspace-root/repos/cascadeguard-open-secure-images`
- **Date:** 2026-04-10 17:10 UTC
- **Artifacts:** 30 discovered, 30 selected

## Summary

| Kind | Found | Issues | Action |
|------|------:|-------:|--------|
| Dockerfiles | 11 | 10 | cascadeguard images pin |
| GitHub Actions | 8 | 2 | cascadeguard actions pin |
| Kubernetes Manifests | 11 | 11 | cascadeguard images pin |

## Dockerfiles

| | Component | Findings | Recommendation |
|---|-----------|----------|----------------|
| ⚠ | images/alpine | alpine:3.20 uses a tag (mutable) | Run: cascadeguard images pin --file images/alpine/Dockerfile |
| ⚠ | images/debian-slim | debian:bookworm-slim uses a tag (mutable) | Run: cascadeguard images pin --file images/debian-slim/Dockerfile |
| ⚠ | images/nginx | nginx:stable-alpine-slim uses a tag (mutable) | Run: cascadeguard images pin --file images/nginx/Dockerfile |
| ⚠ | images/ubuntu | ubuntu:22.04 uses a tag (mutable) | Run: cascadeguard images pin --file images/ubuntu/Dockerfile |
| ⚠ | mysql/8 | mysql:8.0 uses a tag (mutable) | Run: cascadeguard images pin --file images/mysql/8/Dockerfile |
| ⚠ | postgres/16 | postgres:16 uses a tag (mutable) | Run: cascadeguard images pin --file images/postgres/16/Dockerfile |
| ⚠ | openjdk/21 | openjdk:21-slim uses a tag (mutable) | Run: cascadeguard images pin --file images/openjdk/21/Dockerfile |
| ⚠ | golang/1.22 | golang:1.22-alpine uses a tag (mutable) | Run: cascadeguard images pin --file images/golang/1.22/Dockerfile |
| ⚠ | redis/7 | redis:7.4-alpine uses a tag (mutable) | Run: cascadeguard images pin --file images/redis/7/Dockerfile |
| ⚠ | python/3.12 | python:3.12-slim uses a tag (mutable) | Run: cascadeguard images pin --file images/python/3.12/Dockerfile |

<details><summary>Details</summary>

| Component | Path | Finding |
|-----------|------|---------|
| images/alpine | `images/alpine/Dockerfile` | Multi-stage build with 1 stages |
| | | alpine:3.20 uses a tag (mutable) |
| images/debian-slim | `images/debian-slim/Dockerfile` | Multi-stage build with 1 stages |
| | | debian:bookworm-slim uses a tag (mutable) |
| images/nginx | `images/nginx/Dockerfile` | Multi-stage build with 1 stages |
| | | nginx:stable-alpine-slim uses a tag (mutable) |
| images/ubuntu | `images/ubuntu/Dockerfile` | ubuntu:22.04 uses a tag (mutable) |
| mysql/8 | `images/mysql/8/Dockerfile` | mysql:8.0 uses a tag (mutable) |
| postgres/16 | `images/postgres/16/Dockerfile` | postgres:16 uses a tag (mutable) |
| openjdk/21 | `images/openjdk/21/Dockerfile` | openjdk:21-slim uses a tag (mutable) |
| golang/1.22 | `images/golang/1.22/Dockerfile` | golang:1.22-alpine uses a tag (mutable) |
| redis/7 | `images/redis/7/Dockerfile` | redis:7.4-alpine uses a tag (mutable) |
| python/3.12 | `images/python/3.12/Dockerfile` | Multi-stage build with 1 stages |
| | | python:3.12-slim uses a tag (mutable) |

</details>

<details><summary>1 with no findings</summary>

| Component | Path |
|-----------|------|
| node/20 | `images/node/20/Dockerfile` |

</details>

## GitHub Actions

| | Component | Findings | Recommendation |
|---|-----------|----------|----------------|
| ✖ | check-upstream-tags | 3 action references, 1 unpinned | Run: cascadeguard actions pin |
| ✖ | pr-path-guard | 1 action references, 1 unpinned | Run: cascadeguard actions pin |

<details><summary>Details</summary>

| Component | Path | Finding |
|-----------|------|---------|
| check-upstream-tags | `.github/workflows/check-upstream-tags.yaml` | 3 action references, 1 unpinned |
| | | cascadeguard/cascadeguard-actions/check-upstream@main tracks a branch (high risk) |
| pr-path-guard | `.github/workflows/pr-path-guard.yaml` | 1 action references, 1 unpinned |
| | | cascadeguard/cascadeguard-actions/block-sensitive-paths@main tracks a branch (high risk) |

</details>

<details><summary>6 with no findings</summary>

| Component | Path |
|-----------|------|
| build-image | `.github/workflows/build-image.yaml` |
| ci | `.github/workflows/ci.yaml` |
| enforce-actions-policy | `.github/workflows/enforce-actions-policy.yaml` |
| rebuild | `.github/workflows/rebuild.yaml` |
| release | `.github/workflows/release.yaml` |
| scheduled-scan | `.github/workflows/scheduled-scan.yaml` |

</details>

## Kubernetes Manifests

| | Component | Findings | Recommendation |
|---|-----------|----------|----------------|
| △ | ubuntu/test | CVEPolicy with 1 container image(s) | Run: cascadeguard images pin --file images/ubuntu/test/cve-policy.yaml |
| △ | 20/test | CVEPolicy with 1 container image(s) | Run: cascadeguard images pin --file images/node/20/test/cve-policy.yaml |
| △ | 8/test | CVEPolicy with 1 container image(s) | Run: cascadeguard images pin --file images/mysql/8/test/cve-policy.yaml |
| △ | nginx/test | CVEPolicy with 1 container image(s) | Run: cascadeguard images pin --file images/nginx/test/cve-policy.yaml |
| △ | 16/test | CVEPolicy with 1 container image(s) | Run: cascadeguard images pin --file images/postgres/16/test/cve-policy.yaml |
| △ | 21/test | CVEPolicy with 1 container image(s) | Run: cascadeguard images pin --file images/openjdk/21/test/cve-policy.yaml |
| △ | debian-slim/test | CVEPolicy with 1 container image(s) | Run: cascadeguard images pin --file images/debian-slim/test/cve-policy.yaml |
| △ | 1.22/test | CVEPolicy with 1 container image(s) | Run: cascadeguard images pin --file images/golang/1.22/test/cve-policy.yaml |
| △ | 7/test | CVEPolicy with 1 container image(s) | Run: cascadeguard images pin --file images/redis/7/test/cve-policy.yaml |
| △ | 3.12/test | CVEPolicy with 1 container image(s) | Run: cascadeguard images pin --file images/python/3.12/test/cve-policy.yaml |
| △ | alpine/test | CVEPolicy with 1 container image(s) | Run: cascadeguard images pin --file images/alpine/test/cve-policy.yaml |

<details><summary>Details</summary>

| Component | Path | Finding |
|-----------|------|---------|
| ubuntu/test | `images/ubuntu/test/cve-policy.yaml` | CVEPolicy with 1 container image(s) |
| 20/test | `images/node/20/test/cve-policy.yaml` | CVEPolicy with 1 container image(s) |
| 8/test | `images/mysql/8/test/cve-policy.yaml` | CVEPolicy with 1 container image(s) |
| nginx/test | `images/nginx/test/cve-policy.yaml` | CVEPolicy with 1 container image(s) |
| 16/test | `images/postgres/16/test/cve-policy.yaml` | CVEPolicy with 1 container image(s) |
| 21/test | `images/openjdk/21/test/cve-policy.yaml` | CVEPolicy with 1 container image(s) |
| debian-slim/test | `images/debian-slim/test/cve-policy.yaml` | CVEPolicy with 1 container image(s) |
| 1.22/test | `images/golang/1.22/test/cve-policy.yaml` | CVEPolicy with 1 container image(s) |
| 7/test | `images/redis/7/test/cve-policy.yaml` | CVEPolicy with 1 container image(s) |
| 3.12/test | `images/python/3.12/test/cve-policy.yaml` | CVEPolicy with 1 container image(s) |
| alpine/test | `images/alpine/test/cve-policy.yaml` | CVEPolicy with 1 container image(s) |

</details>
