#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuo pipefail

install "${1/intel/intel-oneapi-compiler-dpcpp-cpp}" libstdc++-13-dev

# setvars.sh takes the positional parameters of this script as its arguments and expands unset variables.
set --
set +u
# shellcheck source=/dev/null
source /opt/intel/oneapi/setvars.sh
set -u

sudo ln -fs "$(icpx --print-prog-name=llvm-ar)" /usr/bin/ar
sudo ln -fs "$(icpx --print-prog-name=lld)" /usr/bin/ld
sudo ln -fs "$(icpx --print-prog-name=llvm-nm)" /usr/bin/nm
sudo ln -fs "$(icpx --print-prog-name=llvm-ranlib)" /usr/bin/ranlib
echo "CC=icx" >> "${GITHUB_ENV}"
echo "CXX=icpx" >> "${GITHUB_ENV}"
echo "${PATH}" > "${GITHUB_PATH}"
for VAR in TBBROOT ONEAPI_ROOT PKG_CONFIG_PATH ACL_BOARD_VENDOR_PATH FPGA_VARS_DIR DIAGUTIL_PATH DPL_ROOT MANPATH GDB_INFO \
           SETVARS_COMPLETED CMAKE_PREFIX_PATH CMPLR_ROOT FPGA_VARS_ARGS INFOPATH LIBRARY_PATH OCL_ICD_FILENAMES \
           INTELFPGAOCLSDKROOT LD_LIBRARY_PATH NLSPATH INTEL_PYTHONHOME CPATH; do
    echo "${VAR}=${!VAR-}" >> "${GITHUB_ENV}"
done
