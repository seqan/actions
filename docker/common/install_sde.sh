#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

SDE_EXTRACTION_PATH=$1
SDE_TARGET_FILE="/tmp/sde.tar.xz"

# Fail the script if the SDE_EXTRACTION_PATH is empty
if [[ -z "${SDE_EXTRACTION_PATH}" ]]; then
    echo "SDE_EXTRACTION_PATH is empty. Exiting..."
    exit 1
fi

# Download the SDE tarball
# Update the following variables if the SDE version changes
DIR_PATH="831748"
SDE_VERSION="9.44.0"
SDE_DATE="2024-08-22"

# Example: https://downloadmirror.intel.com/831748/sde-external-9.44.0-2024-08-22-lin.tar.xz
FULL_URL="https://downloadmirror.intel.com/${DIR_PATH}/sde-external-${SDE_VERSION}-${SDE_DATE}-lin.tar.xz"

wget -q -O "${SDE_TARGET_FILE}" "${FULL_URL}"

# Create the extraction directory if it doesn't exist
mkdir -p "${SDE_EXTRACTION_PATH}"

# Extract the tarball file into the extraction directory
tar xf "${SDE_TARGET_FILE}" -C "${SDE_EXTRACTION_PATH}" --strip-components=1

# Clean up
rm "${SDE_TARGET_FILE}"

# Add the SDE version to the versions file
echo -e "intel-sde*\t${SDE_VERSION}" | tee -a /manually_installed_packages.version /installed_packages.version > /dev/null
