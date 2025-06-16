#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

CLANG_VERSION=$1
IWYU_VERSION=$2

IWYU_URL="https://github.com/include-what-you-use/include-what-you-use/archive/refs/tags/${IWYU_VERSION}.tar.gz"

mkdir -p /tmp/iwyu
cd /tmp/iwyu
wget --quiet --retry-connrefused --output-document "${IWYU_VERSION}".tar.gz "${IWYU_URL}"
tar xf "${IWYU_VERSION}".tar.gz
mkdir build && cd build
cmake ../include-what-you-use-"${IWYU_VERSION}" -G "Unix Makefiles" \
                                                -DCMAKE_BUILD_TYPE=Release \
                                                -DCMAKE_INSTALL_PREFIX=/usr \
                                                -DCMAKE_PREFIX_PATH=/usr/lib/llvm-"${CLANG_VERSION}" \
                                                -DCMAKE_C_COMPILER=clang-"${CLANG_VERSION}" \
                                                -DCMAKE_C_FLAGS="-w" \
                                                -DCMAKE_CXX_COMPILER=clang++-"${CLANG_VERSION}" \
                                                -DCMAKE_CXX_FLAGS="-w"
make
make install
echo -e "include-what-you-use*\t${IWYU_VERSION}" | tee -a /manually_installed_packages.version /installed_packages.version > /dev/null
rm -fdr /tmp/iwyu
