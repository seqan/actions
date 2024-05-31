#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

CLANG_VERSION=$1

mv /docker_scripts/clang /usr/bin/clang
sed -i "s/LLVMVERSION/${CLANG_VERSION}/g" /usr/bin/clang

mv /docker_scripts/clang++ /usr/bin/clang++
sed -i "s/LLVMVERSION/${CLANG_VERSION}/g" /usr/bin/clang++
