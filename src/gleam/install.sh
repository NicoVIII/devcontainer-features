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

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Clean up
rm -rf /var/lib/apt/lists/*

echo "Change into tmp directory"
mkdir -p /tmp/gleam-feature
cd /tmp/gleam-feature

export DEBIAN_FRONTEND=noninteractive

arch=$(dpkg --print-architecture)
# Map arch to expected values
case "$arch" in
  "amd64") arch="x86_64" ;;
  "arm64") arch="aarch64" ;;
  *) echo "Unsupported architecture: $arch" && exit 1 ;;
esac

if [ "$GLEAM_VERSION" = "latest" ]; then
  check_packages ca-certificates curl jq wget
  # Determine latest version from GitHub API
  GLEAM_VERSION=$(curl -fsSL https://api.github.com/repos/gleam-lang/gleam/releases/latest | jq -r .tag_name)
else
  check_packages ca-certificates wget
fi

# Remove leading v if present
GLEAM_VERSION="${GLEAM_VERSION#v}"
URL="https://github.com/gleam-lang/gleam/releases/download/v$GLEAM_VERSION/gleam-v$GLEAM_VERSION-$arch-unknown-linux-musl.tar.gz"

echo "Downloading Gleam v$GLEAM_VERSION for $arch from $URL..."
wget -O "gleam-v$GLEAM_VERSION-$arch-unknown-linux-musl.tar.gz" "$URL"
echo "Checking sha256sum..."
wget -qO- "$URL.sha256" | sha256sum -c -
echo "Extract and move to /usr/local/bin"
tar xf "gleam-v$GLEAM_VERSION-$arch-unknown-linux-musl.tar.gz"
chmod +x gleam
mv gleam /usr/local/bin/

# Clean up
cd -
rm -rf /var/lib/apt/lists/* /tmp/gleam-feature

echo "Done!"
