#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

GCC_VERSION=$1

apt-get update
apt-get install --yes --no-install-recommends g++-${GCC_VERSION}

rm -rf /var/lib/apt/lists/*
