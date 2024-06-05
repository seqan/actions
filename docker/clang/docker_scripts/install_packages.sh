#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

CLANG_VERSION=$1

wget -q -O /etc/apt/trusted.gpg.d/apt.llvm.org.asc https://apt.llvm.org/llvm-snapshot.gpg.key
echo "deb http://apt.llvm.org/unstable/ llvm-toolchain-${CLANG_VERSION} main" > /etc/apt/sources.list.d/llvm.list

apt-get update
apt-get install --yes --no-install-recommends \
    llvm-${CLANG_VERSION} \
    clang-${CLANG_VERSION} \
    lld-${CLANG_VERSION} \
    libc++-${CLANG_VERSION}-dev \
    libc++abi-${CLANG_VERSION}-dev \
    libomp-${CLANG_VERSION}-dev \
    libclang-${CLANG_VERSION}-dev \
    clang-format-${CLANG_VERSION} \
    clang-tidy-${CLANG_VERSION}

rm -rf /var/lib/apt/lists/*
