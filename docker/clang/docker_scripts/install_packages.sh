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
    lld-${CLANG_VERSION} \
    llvm-${CLANG_VERSION} \
    llvm-${CLANG_VERSION}-dev

# Overwrite libpython3.11 dependency for libomp-16-dev.
if [[ CLANG_VERSION -eq 16 ]]; then
    cd /tmp
    apt-get download libomp-16-dev
    dpkg-deb -x libomp-16-dev*.deb libomp-16-dev
    dpkg-deb --control libomp-16-dev*.deb libomp-16-dev/DEBIAN
    rm -f libomp-16-dev*.deb
    sed -i 's@libpython3.11 (>= 3.11.5)@libpython3.12 (>= 3.12.0)@g' libomp-16-dev/DEBIAN/control
    dpkg -b libomp-16-dev libomp-16-dev.deb
    apt-get install --yes --no-install-recommends ./libomp-16-dev.deb
    rm -f libomp-16-dev.deb
else
    apt-get install --yes --no-install-recommends libomp-${CLANG_VERSION}-dev
fi

rm -rf /var/lib/apt/lists/*
