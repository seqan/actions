#!/bin/bash -l
set -Eeuxo pipefail

GCC_VERSION=$1

apt-get update
apt-get install --yes --no-install-recommends --no-upgrade wget ca-certificates git cmake gh make ccache gcovr
apt-get install --yes --no-install-recommends g++-${GCC_VERSION}

rm -rf /var/lib/apt/lists/*
