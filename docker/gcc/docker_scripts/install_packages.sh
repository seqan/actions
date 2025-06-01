#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

GCC_VERSION=$1

USE_EXPERIMENTAL=false
APT_ARGS=(--yes --no-install-recommends)

apt-get update 1>/dev/null

# Check gcc instead of g++, because g++ would need escapes for regex expression (g\\+\\+ or similar).
if [[ GCC_VERSION -ge 15 ]] && ! apt-get --simulate install gcc-"${GCC_VERSION}" &>/dev/null; then
    USE_EXPERIMENTAL=true
    APT_ARGS+=(--target-release experimental)
fi

if ${USE_EXPERIMENTAL}; then
    sed -i 's@Suites: unstable@Suites: unstable experimental@' /etc/apt/sources.list.d/debian.sources
    cat /etc/apt/sources.list.d/debian.sources
    apt-get update 1>/dev/null
fi

apt-get install "${APT_ARGS[@]}" g++-"${GCC_VERSION}" 1>/dev/null

rm -rf /var/lib/apt/lists/*
