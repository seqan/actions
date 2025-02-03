#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

apt list --manual-installed 2>/dev/null | \
    grep -v "Listing..." | \
    sed -E 's@(\S+)/\S+ (\S+) \S+ \S+@\1\t\2@g' >> /manually_installed_packages.version

# Some packages might have been added to the list because they are not installable via apt.
sort -o /manually_installed_packages.version /manually_installed_packages.version

apt list --installed 2>/dev/null | \
    grep -v "Listing..." | \
    sed -E 's@(\S+)/\S+ (\S+) \S+ \S+@\1\t\2@g' >> /installed_packages.version

# Some packages might have been added to the list because they are not installable via apt.
sort -o /installed_packages.version /installed_packages.version
