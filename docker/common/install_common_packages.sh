#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

apt-get update
apt-get install --yes --no-install-recommends --no-upgrade \
    ca-certificates \
    ccache \
    cmake \
    curl \
    gcovr \
    gh \
    git \
    gpg \
    libbz2-dev \
    make \
    patch \
    wget \
    zlib1g-dev

rm -rf /var/lib/apt/lists/*
