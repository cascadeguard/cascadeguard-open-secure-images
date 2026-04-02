#!/usr/bin/env bash
# set-nonroot.sh — Create a dedicated nonroot user for running containers.
#
# Creates user 'nonroot' with UID 65532 and GID 65532, matching the
# convention used by distroless and other hardened base images. Sets
# appropriate directory permissions for /app and /tmp.
#
# Part of the CascadeGuard hardening suite.
# https://github.com/cascadeguard/open-secure-images

set -euo pipefail

echo "[cascadeguard] Setting up nonroot user..."

NONROOT_UID=65532
NONROOT_GID=65532
NONROOT_USER="nonroot"
NONROOT_GROUP="nonroot"
NONROOT_HOME="/home/nonroot"

# Detect whether we are on Alpine (busybox adduser) or Debian-based
is_alpine() {
  [ -f /etc/alpine-release ]
}

# Create group if it does not exist
if ! getent group "$NONROOT_GROUP" > /dev/null 2>&1; then
  if is_alpine; then
    addgroup -g "$NONROOT_GID" -S "$NONROOT_GROUP"
  else
    groupadd --gid "$NONROOT_GID" --system "$NONROOT_GROUP"
  fi
  echo "  Created group: $NONROOT_GROUP (GID $NONROOT_GID)"
else
  echo "  Group $NONROOT_GROUP already exists, skipping."
fi

# Create user if it does not exist
if ! id "$NONROOT_USER" > /dev/null 2>&1; then
  if is_alpine; then
    adduser -u "$NONROOT_UID" -G "$NONROOT_GROUP" -s /sbin/nologin -D -H "$NONROOT_USER"
  else
    useradd \
      --uid "$NONROOT_UID" \
      --gid "$NONROOT_GID" \
      --system \
      --no-create-home \
      --home-dir "$NONROOT_HOME" \
      --shell /usr/sbin/nologin \
      "$NONROOT_USER"
  fi
  echo "  Created user: $NONROOT_USER (UID $NONROOT_UID)"
else
  echo "  User $NONROOT_USER already exists, skipping."
fi

# Create home directory with restricted permissions
mkdir -p "$NONROOT_HOME"
chown "$NONROOT_USER:$NONROOT_GROUP" "$NONROOT_HOME"
chmod 750 "$NONROOT_HOME"

# Create /app directory owned by nonroot for application workloads
mkdir -p /app
chown "$NONROOT_USER:$NONROOT_GROUP" /app
chmod 755 /app

# Ensure /tmp is world-writable but with sticky bit
chmod 1777 /tmp

# Lock root account — prevent interactive root login
if command -v passwd > /dev/null 2>&1; then
  passwd -l root > /dev/null 2>&1 || true
fi

echo "[cascadeguard] Nonroot user setup complete (UID=$NONROOT_UID, GID=$NONROOT_GID)."
