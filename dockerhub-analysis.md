# Docker Hub Image Analysis

Last updated: 2026-04-11

Analysis of all 25 images tracked in `images.yaml`, covering deprecation status,
official replacement recommendations, and weekly download data (CAS-494).

---

## Schema Fields

### `deprecated`

**Type:** boolean (`true` / `false`)
**Required:** yes (all entries)

Whether Docker Hub has officially deprecated this image. Docker Hub marks an
image as deprecated when the upstream maintainer has published a notice that
the image will no longer receive updates and users should migrate to a
replacement. A `deprecated: true` image continues to exist on Docker Hub but
will not receive new tags, security patches, or updates beyond a stated
end-of-life date.

Set `deprecated: false` for all images that are actively maintained. Do not
infer deprecation from CVE count or low update frequency — only set `true`
when an official Docker Hub deprecation notice exists.

### `recommended_replacement`

**Type:** string (image reference, e.g. `eclipse-temurin:21-jre-jammy`)
**Required:** only when `deprecated: true`; omit entirely when `deprecated: false`

The upstream-recommended replacement image as stated in the Docker Hub
deprecation notice. Use the most specific tag that represents the stable
long-term target (e.g. prefer `eclipse-temurin:21-jre-jammy` over
`eclipse-temurin:latest`).

When a deprecated image has no official replacement recommendation, set this
field to `null` and note the reason in a comment.

### `weekly_downloads`

**Type:** integer or null
**Required:** yes (all entries)

Weekly pull count as reported by the Docker Hub API
(`GET /v2/repositories/{namespace}/{image}/`). Use the `pull_week` field from
the response. Set to `null` until automated population is in place (CAS-494
placeholder).

Rationale: `pull_count` (total all-time pulls) reflects historical volume but
does not indicate current community activity. `weekly_downloads` gives a
real-time signal for prioritising scan frequency and tier decisions.

---

## Deprecation Audit (2026-04-11)

All 25 images audited against Docker Hub official deprecation notices.

| Image | Deprecated | Replacement | Notes |
|-------|-----------|-------------|-------|
| nginx | no | — | Actively maintained official image |
| alpine | no | — | Actively maintained official image |
| ubuntu | no | — | Actively maintained official image |
| python | no | — | Actively maintained official image |
| postgres | no | — | Actively maintained official image |
| redis | no | — | Actively maintained official image |
| node | no | — | Actively maintained official image |
| mysql | no | — | Actively maintained official image |
| golang | no | — | Actively maintained official image |
| **openjdk** | **yes** | `eclipse-temurin:21-jre-jammy` | Docker Hub deprecation notice; see below |
| memcached | no | — | Actively maintained official image |
| httpd | no | — | Actively maintained official image |
| mongo | no | — | Actively maintained official image |
| rabbitmq | no | — | Actively maintained official image |
| traefik | no | — | Actively maintained official image |
| mariadb | no | — | Actively maintained official image |
| grafana | no | — | Actively maintained official image |
| php | no | — | Actively maintained official image |
| ruby | no | — | Actively maintained official image |
| prometheus | no | — | Actively maintained official image |
| elasticsearch | no | — | Actively maintained official image |
| haproxy | no | — | Actively maintained official image |
| tomcat | no | — | Actively maintained official image |
| consul | no | — | Actively maintained official image |
| vault | no | — | Actively maintained official image |

### openjdk — Deprecated

**Status:** Officially deprecated on Docker Hub.

Docker Hub notice: *"This image is officially deprecated in favor of the
`eclipse-temurin` image, and will receive no further updates after
May 2025. Please adjust your usage accordingly."*

**Recommended replacement:** `eclipse-temurin:21-jre-jammy`

The `eclipse-temurin` image is published by the Eclipse Adoptium working group
and is the community successor to the Oracle-maintained OpenJDK Docker image.
It provides equivalent LTS Java builds with active CVE patching.

**Impact on CascadeGuard:**
- The managed `openjdk` image in this repo (`images/openjdk/21/Dockerfile`)
  continues to build and publish to GHCR but uses an upstream base that will
  not receive further security updates from Docker Hub.
- Migration to `eclipse-temurin:21-jre-jammy` as the base image is tracked
  as a follow-on task (see CAS-471, CAS-495).
- Until migration is complete, CascadeGuard's hardened build adds value by
  applying security patches that the upstream base no longer provides.

---

## Weekly Downloads

All `weekly_downloads` fields are currently `null`. Population requires:

1. An automated job calling the Docker Hub API
   (`GET https://hub.docker.com/v2/repositories/library/{image}/`)
   and reading the `pull_week` field from the response.
2. Scheduled updates (weekly cadence recommended) to keep values fresh.

This is tracked as a follow-on data pipeline task. Until the pipeline is in
place, the field serves as a schema placeholder for downstream consumers
(UI badges, CLI scan, dashboard).
