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
    clang-${CLANG_VERSION} \
    clang-format-${CLANG_VERSION} \
    clang-tidy-${CLANG_VERSION} \
    libc++-${CLANG_VERSION}-dev \
    libc++abi-${CLANG_VERSION}-dev \
    libclang-${CLANG_VERSION}-dev \
    libclang-rt-${CLANG_VERSION}-dev \
    libomp-${CLANG_VERSION}-dev \
    lld-${CLANG_VERSION} \
    llvm-${CLANG_VERSION} \
    llvm-${CLANG_VERSION}-dev

rm -rf /var/lib/apt/lists/*
