#!/bin/bash
set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The install script symlinks the remote user's ~/.claude to the bind-mount target.
# Wrap the pipe in `bash -c` so it applies to readlink, not to `check`.
check "claude symlink target" bash -c "readlink /root/.claude | grep -Fx '/mnt/host-claude'"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
