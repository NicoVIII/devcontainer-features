#!/bin/bash
set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# Check if correct version was installed.
# The 'check' command comes from the dev-container-features-test-lib.
check "amber --version" amber --version | grep "0.5.0-alpha"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
