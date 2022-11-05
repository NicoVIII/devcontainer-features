#/bin/sh
set -e

echo "Try to install pnpm with version '${VERSION}'"
npm install -g pnpm@${VERSION}
echo "pnpm installed!"
