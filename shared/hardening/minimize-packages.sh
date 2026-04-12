#!/usr/bin/env bash
# minimize-packages.sh — Remove unnecessary packages, docs, and caches.
#
# Strips documentation, man pages, locale data, and packages that are
# not required at runtime. Works on both Alpine (apk) and Debian-based
# (apt) distributions.
#
# Part of the CascadeGuard hardening suite.
# https://github.com/cascadeguard/open-secure-images

set -euo pipefail

echo "[cascadeguard] Minimizing packages and cleaning caches..."

# Detect package manager
is_alpine() {
  [ -f /etc/alpine-release ]
}

is_debian() {
  [ -f /etc/debian_version ]
}

# ── Debian / Ubuntu ──────────────────────────────────────────────────
if is_debian; then
  export DEBIAN_FRONTEND=noninteractive

  # Apply all available security patches before removing packages.
  # Upstream slim/distroless images pin to a base digest and do not run
  # apt-get upgrade, so unpatched CVEs accumulate between digest bumps.
  # Running upgrade here ensures every Debian-based image picks up the
  # latest security fixes from the distribution's security repositories.
  echo "  Applying upstream Debian security patches (apt-get upgrade)..."
  apt-get update -qq
  apt-get upgrade -y
  apt-get clean
  rm -rf /var/lib/apt/lists/* /var/cache/apt/*

  # Packages considered unnecessary in a production container
  PACKAGES_TO_REMOVE=(
    wget
    curl
    git
    openssh-client
    vim
    nano
    less
    man-db
    manpages
    info
    perl-doc
    make
    gcc
    cpp
    g++
    binutils
    patch
    diffutils
    file
    xz-utils
    bzip2
    unzip
    dirmngr
    gnupg
    gpg-agent
    apt-utils
    e2fsprogs
  )

  echo "  Removing unnecessary Debian packages..."
  # Collect actually-installed packages first, then remove in a single pass
  # to avoid cascading auto-remove side-effects that break subsequent scripts.
  INSTALLED=()
  for pkg in "${PACKAGES_TO_REMOVE[@]}"; do
    if dpkg -l "$pkg" 2>/dev/null | grep -q '^ii'; then
      INSTALLED+=("$pkg")
    fi
  done
  if [ ${#INSTALLED[@]} -gt 0 ]; then
    apt-get purge -y "${INSTALLED[@]}" > /dev/null 2>&1 || true
  fi

  # Light autoremove (no --purge to avoid cascading into essential deps)
  apt-get autoremove -y > /dev/null 2>&1 || true
  apt-get clean
  rm -rf /var/lib/apt/lists/*
  rm -rf /var/cache/apt/*
  rm -rf /var/log/apt/*
  rm -rf /var/log/dpkg.log

  echo "  Debian packages cleaned."
fi

# ── Alpine ───────────────────────────────────────────────────────────
if is_alpine; then
  # Apply all available security patches before removing packages.
  # Alpine base images do not run apk upgrade, so unpatched CVEs accumulate
  # between upstream tag bumps. This mirrors the Debian apt-get upgrade above.
  echo "  Applying Alpine security patches (apk upgrade)..."
  apk update && apk upgrade --no-cache
  rm -rf /var/cache/apk/*

  ALPINE_PACKAGES_TO_REMOVE=(
    wget
    curl
    git
    openssh-client
    vim
    nano
    less
    man-pages
    gcc
    g++
    make
    binutils
    patch
    file
  )

  echo "  Removing unnecessary Alpine packages..."
  for pkg in "${ALPINE_PACKAGES_TO_REMOVE[@]}"; do
    if apk info -e "$pkg" > /dev/null 2>&1; then
      apk del --no-cache "$pkg" > /dev/null 2>&1 || true
    fi
  done

  rm -rf /var/cache/apk/*
  echo "  Alpine packages cleaned."
fi

# ── Common cleanup (both distros) ───────────────────────────────────
echo "  Removing documentation and unnecessary filesystem artifacts..."

# Remove documentation, man pages, locale data, license files
rm -rf /usr/share/doc/*
rm -rf /usr/share/man/*
rm -rf /usr/share/info/*
rm -rf /usr/share/groff/*
rm -rf /usr/share/lintian/*
rm -rf /usr/share/linda/*
rm -rf /usr/share/locale/*
rm -rf /usr/share/i18n/*

# Keep only minimal locales if locales directory exists
if [ -d /usr/lib/locale ]; then
  find /usr/lib/locale -mindepth 1 -maxdepth 1 \
    ! -name 'C.UTF-8' ! -name 'en_US.utf8' \
    -exec rm -rf {} + 2>/dev/null || true
fi

# Remove log files
rm -rf /var/log/*.log
rm -rf /var/log/lastlog
rm -rf /var/log/faillog

# NOTE: /tmp is intentionally NOT cleared here. The Dockerfiles that call
# this script store other hardening scripts in /tmp and clean them up
# explicitly after all scripts have run (rm -rf /tmp/*.sh). Clearing /tmp
# here would delete set-nonroot.sh and strip-shells.sh before they execute,
# causing a "command not found" (exit 127) error in the RUN chain.
# /var/tmp is also left alone for the same reason.

# Remove Python byte-compiled files if Python is not the primary runtime
# (skip this for Python-based images — handled in their Dockerfiles)

echo "[cascadeguard] Package minimization complete."
