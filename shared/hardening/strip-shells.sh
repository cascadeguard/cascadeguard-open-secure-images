#!/usr/bin/env bash
# strip-shells.sh — Remove unnecessary shell binaries from the image.
#
# Keeps /bin/sh available during build but removes alternative shells
# (bash, dash, csh, zsh, etc.) from non-essential paths. This reduces
# the attack surface by limiting interactive shell access in production.
#
# Part of the CascadeGuard hardening suite.
# https://github.com/cascadeguard/open-secure-images

set -euo pipefail

echo "[cascadeguard] Stripping unnecessary shell binaries..."

# Shells to remove — we preserve /bin/sh (required for RUN directives during build)
SHELLS_TO_REMOVE=(
  /bin/bash
  /bin/dash
  /bin/csh
  /bin/tcsh
  /bin/zsh
  /bin/ksh
  /usr/bin/bash
  /usr/bin/dash
  /usr/bin/csh
  /usr/bin/tcsh
  /usr/bin/zsh
  /usr/bin/ksh
)

removed=0
for shell in "${SHELLS_TO_REMOVE[@]}"; do
  if [ -f "$shell" ] || [ -L "$shell" ]; then
    rm -f "$shell"
    echo "  Removed: $shell"
    removed=$((removed + 1))
  fi
done

# Remove shell-related profile files that are not needed in production
PROFILE_PATHS=(
  /etc/bash.bashrc
  /etc/bash.bash_logout
  /root/.bashrc
  /root/.bash_profile
  /root/.bash_logout
  /root/.profile
  /etc/csh.cshrc
  /etc/csh.login
  /etc/zsh
)

for profile in "${PROFILE_PATHS[@]}"; do
  if [ -e "$profile" ]; then
    rm -rf "$profile"
    echo "  Removed profile: $profile"
  fi
done

# Remove shell completion directories
for dir in /usr/share/bash-completion /usr/share/zsh /etc/bash_completion.d; do
  if [ -d "$dir" ]; then
    rm -rf "$dir"
    echo "  Removed completion dir: $dir"
  fi
done

# Update /etc/shells to only list /bin/sh
if [ -f /etc/shells ]; then
  echo "/bin/sh" > /etc/shells
  echo "  Updated /etc/shells to contain only /bin/sh"
fi

echo "[cascadeguard] Shell stripping complete. Removed $removed shell binaries."
