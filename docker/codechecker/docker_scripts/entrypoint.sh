#!/bin/bash

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

source /venv/codechecker/bin/activate

# Check if a command is provided; if not, default to bash
if [ $# -eq 0 ]; then
  exec bash
else
  exec "$@"
fi
