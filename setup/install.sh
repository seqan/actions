#!/usr/bin/env bash
set -Eeuo pipefail

if [ "$RUNNER_OS" == "Linux" ]; then
    sudo apt-get install --yes "$@"
else
    ${GITHUB_ACTION_PATH}/install_via_brew.sh "$@"
fi
