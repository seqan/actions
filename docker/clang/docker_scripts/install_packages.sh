#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

CLANG_VERSION=$1

wget --quiet --retry-connrefused --output-document /etc/apt/trusted.gpg.d/apt.llvm.org.asc https://apt.llvm.org/llvm-snapshot.gpg.key

cat > /etc/apt/preferences.d/llvm-pin <<- EOM
Package: *
Pin: origin apt.llvm.org
Pin-Priority: 999
EOM

cat > /etc/apt/sources.list.d/llvm.sources <<- EOM
Types: deb
URIs: https://apt.llvm.org/unstable/
Suites: llvm-toolchain-${CLANG_VERSION}
Components: main
Signed-By: /etc/apt/trusted.gpg.d/apt.llvm.org.asc
EOM

# Warning: OpenPGP signature verification failed: https://apt.llvm.org/unstable llvm-toolchain-21 InRelease:
#  Sub-process /usr/bin/sqv returned an error code (1), error message is:
#   Signing key on 6084F3CF814B57C1CF12EFD515CF4D18AF4F7421 is not bound:
#    No binding signature at time 2025-12-21T23:13:57Z because:
#     Policy rejected non-revocation signature (PositiveCertification) requiring second pre-image resistance because:
#      SHA1 is not considered secure since 2026-02-01T00:00:00Z
# Error: The repository 'https://apt.llvm.org/unstable llvm-toolchain-21 InRelease' is not signed.
#
# https://docs.rs/sequoia-policy-config/latest/sequoia_policy_config/#cutoff-times
mkdir -p /etc/crypto-policies/back-ends
cat > /etc/crypto-policies/back-ends/sequoia.config <<- EOM
[hash_algorithms]
sha1 = "always"
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

# Detect available libpython version
PYTHON_VERSION=$(apt-cache policy libpython3-dev | grep Candidate | grep -oP '3\.\d+')

# Try to install libomp normally
if ! apt-get install --yes --no-install-recommends libomp-"${CLANG_VERSION}"-dev 1>/dev/null 2>&1; then
    echo "libomp-${CLANG_VERSION}-dev installation failed, applying libpython dependency fix..."

    mkdir -p /tmp/libomp
    cd /tmp/libomp
    apt-get download libomp-"${CLANG_VERSION}"-dev
    dpkg-deb -x libomp-"${CLANG_VERSION}"-dev*.deb libomp-"${CLANG_VERSION}"-dev
    dpkg-deb --control libomp-"${CLANG_VERSION}"-dev*.deb libomp-"${CLANG_VERSION}"-dev/DEBIAN
    rm -f libomp-"${CLANG_VERSION}"-dev*.deb

    # Replace any libpython3.X dependency with the available version
    sed -i -E "s@libpython3\.[0-9]+[a-z0-9]* \([^)]+\)@libpython${PYTHON_VERSION} (>= ${PYTHON_VERSION}.0)@g" \
        libomp-"${CLANG_VERSION}"-dev/DEBIAN/control

    dpkg -b libomp-"${CLANG_VERSION}"-dev libomp-"${CLANG_VERSION}"-dev.deb
    apt-get install --yes --no-install-recommends ./libomp-"${CLANG_VERSION}"-dev.deb
    rm -f libomp-"${CLANG_VERSION}"-dev.deb
    cd /
    rm -fdr /tmp/libomp
fi

rm -rf /var/lib/apt/lists/*
