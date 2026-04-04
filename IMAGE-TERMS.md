# CascadeGuard Container Image Artifact Terms

Last updated: 2026-04-04

## Summary

CascadeGuard publishes pre-built container images to public registries (GitHub
Container Registry, Docker Hub). These terms govern your use of those published
image artifacts.

## Permitted Use

You may:

- **Pull and use** any CascadeGuard image in your own applications, services,
  and infrastructure, including production environments
- **Extend** CascadeGuard images by using them as base images in your own
  Dockerfiles (e.g. `FROM ghcr.io/cascadeguard/python:3.12-slim`)
- **Inspect** image layers, SBOMs, and signatures for your own security
  assessment

## Restrictions

You may not:

- **Redistribute** CascadeGuard images by republishing them to other public
  registries, mirror services, or distribution networks under any name
- **Resell** CascadeGuard images or offer them as part of a competing commercial
  container image service
- **Remove or alter** copyright notices, license files, or image labels embedded
  in the images
- **Claim authorship** of CascadeGuard images or present them as your own work

## Source Code vs. Image Artifacts

The **source code** in this repository (Dockerfiles, scripts, configuration,
policies) is licensed under the Business Source License 1.1 as described in the
[LICENSE](LICENSE) file.

The **published container image artifacts** (the built OCI images on GHCR and
Docker Hub) are provided under these Image Terms. The distinction is:

| Asset | License / Terms | Location |
|-------|----------------|----------|
| Source code | BSL 1.1 (see [LICENSE](LICENSE)) | This repository |
| Published images | These Image Terms | `ghcr.io/cascadeguard/*` |

## No Warranty

Published images are provided "as is" without warranty of any kind. See the
[LICENSE](LICENSE) file for full warranty disclaimer terms.

## Changes to These Terms

CascadeGuard may update these terms. Continued use of published images after
changes constitutes acceptance. Material changes will be announced in the
repository's release notes.

## Contact

For licensing questions or commercial arrangements, contact:
licensing@cascadeguard.io
