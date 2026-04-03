# Security Policy

## Supported Versions

| Image Variant | Supported |
|---|---|
| Alpine 3.20 | :white_check_mark: |
| Debian Slim (bookworm) | :white_check_mark: |
| Python 3.12 | :white_check_mark: |
| Node.js 20 | :white_check_mark: |
| Nginx (stable) | :white_check_mark: |

Only the latest published tag of each variant receives security updates.

## Reporting a Vulnerability

**Please do not open a public GitHub issue for security vulnerabilities.**

Instead, use one of these channels:

1. **GitHub Private Vulnerability Reporting** — click "Report a vulnerability" on the [Security tab](https://github.com/cascadeguard/cascadeguard-open-secure-images/security/advisories) of this repository.
2. **Email** — send details to **security@cascadeguard.dev**.

### What to include

- Affected image variant(s) and tag/digest
- Description of the vulnerability and its impact
- Steps to reproduce (if applicable)
- Any suggested fix or mitigation

### Response timeline

| Stage | SLA |
|---|---|
| Acknowledgment of report | 24 hours |
| Initial assessment and timeline | 48 hours |
| Fix for Critical severity | 24 hours |
| Fix for High severity | 48 hours |

See [CVE-STRATEGY.md](CVE-STRATEGY.md) for the full remediation SLA and process.

## Security Practices

This project follows these security practices:

- **Daily vulnerability scanning** with Grype and Trivy against NVD, OSV, and GitHub Advisory databases
- **Build-time gating** — critical and high CVEs block image release
- **Cryptographic signing** — all published images are signed with cosign
- **SBOM generation** — every image includes a Software Bill of Materials
- **Minimal attack surface** — unnecessary packages, shells, and setuid binaries are removed during hardening
- **Pinned dependencies** — base images and CI actions are pinned by digest/SHA

## Acknowledgments

We appreciate the security research community's efforts to make container images safer. Reporters who follow responsible disclosure will be credited in the advisory (unless they prefer to remain anonymous).
