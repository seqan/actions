#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

INTEL_VERSION=$1

apt-get update
apt-get install --yes --no-install-recommends --no-upgrade \
    ca-certificates \
    ccache \
    cmake \
    gh \
    git \
    libbz2-dev \
    make \
    wget \
    zlib1g-dev \

wget -q -O /etc/apt/trusted.gpg.d/apt.repos.intel.com.asc https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
echo "deb https://apt.repos.intel.com/oneapi all main" > /etc/apt/sources.list.d/oneAPI.list

apt-get update
apt-get install --yes --no-install-recommends intel-oneapi-compiler-dpcpp-cpp-${INTEL_VERSION} libstdc++-14-dev
rm -rf /var/lib/apt/lists/*
