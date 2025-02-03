#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

CLANG_VERSION=$1

ln -fs /usr/bin/llvm-as-${CLANG_VERSION} /usr/bin/as
ln -fs /usr/bin/llvm-ar-${CLANG_VERSION} /usr/bin/ar
ln -fs /usr/bin/ld.lld-${CLANG_VERSION} /usr/bin/ld
ln -fs /usr/bin/llvm-nm-${CLANG_VERSION} /usr/bin/nm
ln -fs /usr/bin/llvm-ranlib-${CLANG_VERSION} /usr/bin/ranlib
ln -fs /usr/bin/clang /usr/bin/cc
ln -fs /usr/bin/clang++ /usr/bin/c++
