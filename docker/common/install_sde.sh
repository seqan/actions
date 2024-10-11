#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
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
# Update the link here if the version changes
wget -q -O ${SDE_TARGET_FILE} https://downloadmirror.intel.com/823664/sde-external-9.38.0-2024-04-18-lin.tar.xz

# Create the extraction directory if it doesn't exist
mkdir -p ${SDE_EXTRACTION_PATH}

# Extract the tarball file into the extraction directory
tar xf ${SDE_TARGET_FILE} -C ${SDE_EXTRACTION_PATH} --strip-components=1

# Clean up
rm ${SDE_TARGET_FILE}

# Add the SDE version to the versions file
echo -e "intel-sde*\t9.38" | tee -a /manually_installed_packages.version /installed_packages.version > /dev/null
