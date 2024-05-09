#!/bin/bash -l
set -Eeuxo pipefail

INTEL_VERSION=$1

apt-get update
apt-get install --yes --no-install-recommends --no-upgrade wget ca-certificates git cmake gh make ccache

wget -q -O /etc/apt/trusted.gpg.d/apt.repos.intel.com.asc https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
echo "deb https://apt.repos.intel.com/oneapi all main" > /etc/apt/sources.list.d/oneAPI.list

apt-get update
apt-get install --yes --no-install-recommends intel-oneapi-compiler-dpcpp-cpp-${INTEL_VERSION} libstdc++-14-dev
rm -rf /var/lib/apt/lists/*
