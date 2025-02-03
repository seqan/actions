#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuo pipefail

CMAKE_VERSION="$1"

if [ "${RUNNER_OS}" == "Linux" ]; then
    OS="Linux-x86_64"
    CMAKE_PATH="/tmp/cmake-${CMAKE_VERSION}-${OS}/bin"
elif [ "${RUNNER_OS}" == "macOS" ]; then
    if [[ "${CMAKE_VERSION}" > "3.19.1" ]]; then
        OS="macos-universal"
    else
        OS="Darwin-x86_64"
    fi
    CMAKE_PATH="/tmp/cmake-${CMAKE_VERSION}-${OS}/CMake.app/Contents/bin"
else
    echo "OS ${$RUNNER_OS} is not supported"
    exit 1
fi

mkdir -p /tmp/cmake-download
wget --retry-connrefused --waitretry=30 --read-timeout=30 --timeout=30 --tries=20 --no-clobber --quiet --directory-prefix=/tmp/cmake-download/ https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-${OS}.tar.gz
tar -C /tmp/ -zxf /tmp/cmake-download/cmake-${CMAKE_VERSION}-${OS}.tar.gz
echo "${CMAKE_PATH}" >> $GITHUB_PATH # Only available in subsequent steps!
