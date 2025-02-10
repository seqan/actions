#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

CLANG_VERSION=$1

wget -q -O /etc/apt/trusted.gpg.d/apt.llvm.org.asc https://apt.llvm.org/llvm-snapshot.gpg.key

cat > /etc/apt/sources.list.d/llvm.sources <<- EOM
Types: deb
URIs: https://apt.llvm.org/unstable/
Suites: llvm-toolchain-${CLANG_VERSION}
Components: main
Signed-By: /etc/apt/trusted.gpg.d/apt.llvm.org.asc
EOM

apt-get update 1>/dev/null
apt-get install --yes --no-install-recommends \
    clang-"${CLANG_VERSION}" \
    clang-format-"${CLANG_VERSION}" \
    clang-tidy-"${CLANG_VERSION}" \
    libc++-"${CLANG_VERSION}"-dev \
    libc++abi-"${CLANG_VERSION}"-dev \
    libclang-"${CLANG_VERSION}"-dev \
    libclang-rt-"${CLANG_VERSION}"-dev \
    lld-"${CLANG_VERSION}" \
    llvm-"${CLANG_VERSION}" \
    llvm-"${CLANG_VERSION}"-dev \
    1>/dev/null

# Overwrite libpython3.11 dependency for libomp-16-dev.
if [[ CLANG_VERSION -eq 16 ]]; then
    mkdir -p /tmp/libomp
    cd /tmp/libomp
    apt-get download libomp-16-dev
    dpkg-deb -x libomp-16-dev*.deb libomp-16-dev
    dpkg-deb --control libomp-16-dev*.deb libomp-16-dev/DEBIAN
    rm -f libomp-16-dev*.deb
    sed -i 's@libpython3.11 (>= 3.11.5)@libpython3.12 (>= 3.12.0)@g' libomp-16-dev/DEBIAN/control
    dpkg -b libomp-16-dev libomp-16-dev.deb
    apt-get install --yes --no-install-recommends ./libomp-16-dev.deb
    rm -f libomp-16-dev.deb
    rm -fdr /tmp/libomp
else
    apt-get install --yes --no-install-recommends libomp-"${CLANG_VERSION}"-dev 1>/dev/null
fi

rm -rf /var/lib/apt/lists/*
