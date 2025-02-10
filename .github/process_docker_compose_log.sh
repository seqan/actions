#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuo pipefail

INPUT_FILE=$1
PREFIX=$2
OUTPUT_FILE=${3:-/dev/stdout}

extract_by_prefix(){
    awk "
        BEGIN { in_block = 0 }
        /^#[0-9]+ \[${PREFIX}/ { in_block = 1 }
        /^$/ { if (in_block) { print ""; in_block = 0 } }
        { if (in_block) print }
        " "${INPUT_FILE}"
}

merge_blocks(){
    awk '
    /#[0-9]+ \.\.\./ { getline; getline; next }
    # Print the current line
    { print }
    '
}

extract_by_prefix | merge_blocks > "${OUTPUT_FILE}"
