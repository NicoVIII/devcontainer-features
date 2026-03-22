#!/usr/bin/env bash
set -e

GLEAM_VERSION=${VERSION:-"latest"}

# Checks if packages are installed and installs them if not
check_packages() {
  if ! dpkg -s "$@" > /dev/null 2>&1; then
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
    apt-get -y install --no-install-recommends "$@"
  fi
}

# Clean up
rm -rf /var/lib/apt/lists/*

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Change into tmp directory
mkdir -p /tmp/gleam-feature
cd /tmp/gleam-feature

export DEBIAN_FRONTEND=noninteractive

check_packages wget
arch=$(dpkg --print-architecture)

if [ "$GLEAM_VERSION" = "latest" ]; then
  URL="" # TODO
  echo -e "Unsupported GLEAM version: latest.\nPlease set a specific version for now."
  exit 1
else
  # Remove leading v if present
  GLEAM_VERSION="${GLEAM_VERSION#v}"

  URL="https://github.com/gleam-lang/gleam/releases/download/v$GLEAM_VERSION/gleam-v$GLEAM_VERSION-$arch-unknown-linux-musl.tar.gz"
  # Download and check sha256sum
  wget -qO "gleam-v$GLEAM_VERSION-$arch-unknown-linux-musl.tar.gz" "$URL"
  wget -qO- "$URL.sha256" | sha256sum -c -
  # Extract and move to /usr/local/bin
  tar xf "gleam-v$GLEAM_VERSION-$arch-unknown-linux-musl.tar.gz"
  chmod +x gleam
  mv gleam /usr/local/bin/
fi

cd -
echo "Done!"
