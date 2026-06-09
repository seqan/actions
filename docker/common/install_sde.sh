#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

SDE_EXTRACTION_PATH=$1
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SDE_ARCHIVE="${SCRIPT_DIR}/sde.tar.xz"

# Fail the script if the SDE_EXTRACTION_PATH is empty
if [[ -z "${SDE_EXTRACTION_PATH}" ]]; then
    echo "SDE_EXTRACTION_PATH is empty. Exiting..."
    exit 1
fi

# Create the extraction directory if it doesn't exist
mkdir -p "${SDE_EXTRACTION_PATH}"

# Extract the tarball file into the extraction directory
tar xf "${SDE_ARCHIVE}" -C "${SDE_EXTRACTION_PATH}" --strip-components=1

# Clean up
rm "${SDE_ARCHIVE}"

# Add the SDE version to the versions file
echo -e "intel-sde*\t$(sde --version | grep -oP 'Version:\s*\K[0-9.]+')" | tee -a /manually_installed_packages.version /installed_packages.version > /dev/null
