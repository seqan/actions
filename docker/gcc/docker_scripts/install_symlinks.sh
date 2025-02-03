#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

GCC_VERSION=$1

ln -fs /usr/bin/gcc-${GCC_VERSION} /usr/bin/gcc
ln -fs /usr/bin/g++-${GCC_VERSION} /usr/bin/g++
ln -fs /usr/bin/gcc-${GCC_VERSION} /usr/bin/cc
ln -fs /usr/bin/g++-${GCC_VERSION} /usr/bin/c++

update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-${GCC_VERSION} 100
