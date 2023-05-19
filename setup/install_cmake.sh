#!/usr/bin/env bash
set -Eeuo pipefail

if [ "$RUNNER_OS" == "Linux" ]; then
    OS="Linux"
    CMAKE_PATH="/tmp/cmake-${CMAKE_VERSION}-${OS}-x86_64/bin"
else
    OS="Darwin"
    CMAKE_PATH="/tmp/cmake-${CMAKE_VERSION}-${OS}-x86_64/CMake.app/Contents/bin"
fi

mkdir -p /tmp/cmake-download
wget --retry-connrefused --waitretry=30 --read-timeout=30 --timeout=30 --tries=20 --no-clobber --quiet --directory-prefix=/tmp/cmake-download/ https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-${OS}-x86_64.tar.gz
tar -C /tmp/ -zxf /tmp/cmake-download/cmake-${CMAKE_VERSION}-${OS}-x86_64.tar.gz
echo "${CMAKE_PATH}" >> $GITHUB_PATH # Only available in subsequent steps!
