#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuo pipefail

if [[ -z "${GNUMAKEFLAGS+x}" ]]; then
    echo "GNUMAKEFLAGS is not set."
    exit 1
fi

if [[ -z "${MAKEFLAGS+x}" ]]; then
    echo "MAKEFLAGS is not set."
    exit 1
fi

if [[ "${GNUMAKEFLAGS}" != "${MAKEFLAGS}" ]]; then
    echo "GNUMAKEFLAGS and MAKEFLAGS are not the same."
    echo "GNUMAKEFLAGS: \"${GNUMAKEFLAGS}\""
    echo "MAKEFLAGS: \"${MAKEFLAGS}\""
    exit 1
fi

J_VALUE=$(echo "$GNUMAKEFLAGS" | grep -oP '(?<=-j)[0-9]+')

if [[ J_VALUE -ne $(nproc) ]]; then
    echo "The number of threads in MAKEFLAGS/GNUMAKEFLAGS is not equal to the number of available threads."
    echo "MAKEFLAGS/GNUMAKEFLAGS: \"${GNUMAKEFLAGS}\""
    echo "Number of available threads: $(nproc)"
    exit 1
fi
