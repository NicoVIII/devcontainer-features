#!/bin/bash
set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

check_node() {
    VERSION=$(node -v)
    echo "$VERSION"
    if [[ $VERSION == v16.* ]] # * is used for pattern matching
    then
        echo "Version is 16."
        return 0
    else
        echo "Version is NOT 16!"
        return 1
    fi
}

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "pnpm -v" pnpm -v
check "node -v" check_node

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
