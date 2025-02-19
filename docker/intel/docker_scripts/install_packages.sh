#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

INTEL_VERSION=$1

wget --quiet --retry-connrefused --output-document /etc/apt/trusted.gpg.d/apt.repos.intel.com.asc https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB

# !TODO! Remove 'Trusted: yes'
# https://community.intel.com/t5/oneAPI-Registration-Download/intel-oneapi-installation-failes-on-debian-trixie-currently/m-p/1658005
# apt now uses sqv (a rust port for gpg verification) which does not support the key type used by the intel gpg key
cat > /etc/apt/sources.list.d/oneAPI.sources <<- EOM
Types: deb
URIs: https://apt.repos.intel.com/oneapi/
Suites: all
Components: main
Signed-By: /etc/apt/trusted.gpg.d/apt.repos.intel.com.asc
Trusted: yes
EOM

apt-get update 1>/dev/null
apt-get install --yes --no-install-recommends intel-oneapi-compiler-dpcpp-cpp-"${INTEL_VERSION}" libstdc++-14-dev 1>/dev/null
rm -rf /var/lib/apt/lists/*
