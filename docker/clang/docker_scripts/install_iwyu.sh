#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

CLANG_VERSION=$1

# Define the mapping between IWYU_VERSION and CLANG_VERSION
declare -A version_map=(
    [15]="0.19"
    [16]="0.20"
    [17]="0.21"
    [18]="0.22"
    [19]="0.23"
    [20]="master"
)

IWYU_VERSION=${version_map[${CLANG_VERSION}]}

if [ -z "$IWYU_VERSION" ]; then
    echo "::warning::No corresponding IWYU_VERSION found for CLANG_VERSION ${CLANG_VERSION}"
    exit 0
fi

IWYU_URL="https://github.com/include-what-you-use/include-what-you-use/archive/refs/"
if [ "${IWYU_VERSION}" == "master" ]; then
    IWYU_URL+="heads/"
else
    IWYU_URL+="tags/"
fi
IWYU_URL+="${IWYU_VERSION}.tar.gz"

mkdir -p /tmp/iwyu
cd /tmp/iwyu
wget -q -O ${IWYU_VERSION}.tar.gz ${IWYU_URL}
tar xf ${IWYU_VERSION}.tar.gz
mkdir build && cd build
cmake ../include-what-you-use-${IWYU_VERSION} -G "Unix Makefiles" \
                                              -DCMAKE_BUILD_TYPE=Release \
                                              -DCMAKE_INSTALL_PREFIX=/usr \
                                              -DCMAKE_PREFIX_PATH=/usr/lib/llvm-${CLANG_VERSION} \
                                              -DCMAKE_C_COMPILER=clang-${CLANG_VERSION} \
                                              -DCMAKE_C_FLAGS="-w" \
                                              -DCMAKE_CXX_COMPILER=clang++-${CLANG_VERSION} \
                                              -DCMAKE_CXX_FLAGS="-w"
make -j $(nproc)
make install
echo -e "include-what-you-use*\t${IWYU_VERSION}" | tee -a /manually_installed_packages.version /installed_packages.version > /dev/null
rm -fdr /tmp/iwyu
