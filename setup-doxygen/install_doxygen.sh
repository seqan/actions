#!/usr/bin/env bash
set -Eeuo pipefail

DOXYGEN_VERSION="$1"

if [ "$RUNNER_OS" != "Linux" ]; then
    echo "OS ${$RUNNER_OS} is not supported"
    exit 1
fi

sudo apt-get install graphviz # graphviz for dot
mkdir -p /tmp/doxygen-download
wget --retry-connrefused --waitretry=30 --read-timeout=30 --timeout=30 --tries=20 --no-clobber --quiet --directory-prefix=/tmp/doxygen-download/ https://github.com/doxygen/doxygen/releases/download/Release_${DOXYGEN_VERSION//./_}/doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz
tar -C /tmp/ -zxf /tmp/doxygen-download/doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz
echo "/tmp/doxygen-${DOXYGEN_VERSION}/bin" >> $GITHUB_PATH # Only available in subsequent steps!
