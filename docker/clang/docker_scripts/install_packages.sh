#!/bin/bash -l
set -Eeuxo pipefail

CLANG_VERSION=$1

apt-get update
apt-get install --yes --no-install-recommends --no-upgrade wget ca-certificates git cmake gh make ccache

wget -q -O /etc/apt/trusted.gpg.d/apt.llvm.org.asc https://apt.llvm.org/llvm-snapshot.gpg.key
echo "deb http://apt.llvm.org/unstable/ llvm-toolchain-${CLANG_VERSION} main" > /etc/apt/sources.list.d/llvm.list

apt-get update
apt-get install --yes --no-install-recommends llvm-${CLANG_VERSION} clang-${CLANG_VERSION} lld-${CLANG_VERSION} \
        libc++-${CLANG_VERSION}-dev libc++abi-${CLANG_VERSION}-dev libomp-${CLANG_VERSION}-dev libclang-${CLANG_VERSION}-dev

rm -rf /var/lib/apt/lists/*
