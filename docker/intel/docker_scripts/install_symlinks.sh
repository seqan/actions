#!/bin/bash -l

# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuxo pipefail

INTEL_VERSION=$1

ln -fs /opt/intel/oneapi/compiler/${INTEL_VERSION}/bin/icx /usr/bin/cc
ln -fs /opt/intel/oneapi/compiler/${INTEL_VERSION}/bin/icpx /usr/bin/c++
ln -fs /opt/intel/oneapi/compiler/${INTEL_VERSION}/bin/compiler/llvm-ar /usr/bin/ar
ln -fs /opt/intel/oneapi/compiler/${INTEL_VERSION}/bin/compiler/lld /usr/bin/ld
ln -fs /opt/intel/oneapi/compiler/${INTEL_VERSION}/bin/compiler/llvm-nm /usr/bin/nm
ln -fs /opt/intel/oneapi/compiler/${INTEL_VERSION}/bin/compiler/llvm-ranlib /usr/bin/ranlib
