#!/usr/bin/env bash
# sign-and-attest.sh — Sign container images and attach SBOM attestation.
#
# Uses cosign keyless signing via GitHub Actions OIDC identity. Generates
# an SBOM with syft and attaches it as an in-toto attestation to the image.
#
# Usage:
#   ./sign-and-attest.sh <image-ref>
#
# Environment variables:
#   COSIGN_EXPERIMENTAL   — Set to "1" for keyless signing (default)
#   REGISTRY              — Target registry (default: ghcr.io)
#   SBOM_FORMAT           — SBOM output format (default: spdx-json)
#
# Requires: cosign, syft, jq
#
# Part of the CascadeGuard signing suite.
# https://github.com/cascadeguard/open-secure-images

set -euo pipefail

# ── Configuration ────────────────────────────────────────────────────

IMAGE_REF="${1:?Usage: sign-and-attest.sh <image-ref>}"
COSIGN_EXPERIMENTAL="${COSIGN_EXPERIMENTAL:-1}"
SBOM_FORMAT="${SBOM_FORMAT:-spdx-json}"
SBOM_OUTPUT_FILE="/tmp/sbom-$(date +%s).json"

export COSIGN_EXPERIMENTAL

echo "============================================="
echo "CascadeGuard Image Signing & Attestation"
echo "============================================="
echo "Image:       $IMAGE_REF"
echo "SBOM format: $SBOM_FORMAT"
echo ""

# ── Preflight checks ────────────────────────────────────────────────

for tool in cosign syft jq; do
  if ! command -v "$tool" > /dev/null 2>&1; then
    echo "ERROR: Required tool '$tool' is not installed." >&2
    exit 1
  fi
done

# Verify we are running in a GitHub Actions environment with OIDC
if [ -z "${ACTIONS_ID_TOKEN_REQUEST_URL:-}" ]; then
  echo "WARNING: ACTIONS_ID_TOKEN_REQUEST_URL is not set."
  echo "         Keyless signing requires GitHub Actions OIDC."
  echo "         Falling back to interactive signing if available."
fi

# ── Step 1: Sign the image ──────────────────────────────────────────

echo "[1/4] Signing image with cosign (keyless)..."
cosign sign \
  --yes \
  --recursive \
  -a "repo=$(echo "$IMAGE_REF" | cut -d: -f1)" \
  -a "sha=$(echo "$IMAGE_REF" | cut -d@ -f2 2>/dev/null || echo 'N/A')" \
  -a "build_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  -a "builder=cascadeguard-ci" \
  "$IMAGE_REF"

echo "  Image signed successfully."

# ── Step 2: Generate SBOM ───────────────────────────────────────────

echo "[2/4] Generating SBOM with syft..."
syft \
  "$IMAGE_REF" \
  --output "$SBOM_FORMAT=$SBOM_OUTPUT_FILE" \
  --quiet

PACKAGE_COUNT=$(jq '.packages | length' "$SBOM_OUTPUT_FILE" 2>/dev/null || echo "unknown")
echo "  SBOM generated: $SBOM_OUTPUT_FILE ($PACKAGE_COUNT packages)"

# ── Step 3: Attach SBOM attestation ─────────────────────────────────

echo "[3/4] Attaching SBOM attestation..."
cosign attest \
  --yes \
  --predicate "$SBOM_OUTPUT_FILE" \
  --type spdxjson \
  "$IMAGE_REF"

echo "  SBOM attestation attached."

# ── Step 4: Verify the signature ────────────────────────────────────

echo "[4/4] Verifying image signature..."
cosign verify \
  --certificate-identity-regexp "https://github.com/cascadeguard/.*" \
  --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
  "$IMAGE_REF" > /dev/null 2>&1

echo "  Signature verification passed."

# ── Cleanup ──────────────────────────────────────────────────────────

rm -f "$SBOM_OUTPUT_FILE"

echo ""
echo "============================================="
echo "Signing and attestation complete."
echo "  Image: $IMAGE_REF"
echo "  Signed: yes (keyless / Fulcio + Rekor)"
echo "  SBOM:   attached ($SBOM_FORMAT)"
echo "============================================="
