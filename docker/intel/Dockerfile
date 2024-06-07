# syntax=docker/dockerfile:1

# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

FROM debian:unstable-slim

ARG INTEL_VERSION=2024.1

SHELL ["/bin/bash", "-Eeuxo", "pipefail", "-c"]

COPY docker_scripts /docker_scripts
COPY --from=common install_common_packages.sh /docker_scripts/

RUN /docker_scripts/install_common_packages.sh && \
    /docker_scripts/install_packages.sh ${INTEL_VERSION} && \
    /docker_scripts/install_symlinks.sh ${INTEL_VERSION}

ENV CC=icx
ENV CXX=icpx

ENV ACL_BOARD_VENDOR_PATH=/opt/Intel/OpenCLFPGA/oneAPI/Boards
ENV CMAKE_PREFIX_PATH=/opt/intel/oneapi/tbb/2021.12/env/..:/opt/intel/oneapi/dpl/2022.5/lib/cmake/oneDPL:/opt/intel/oneapi/compiler/2024.1
ENV CMPLR_ROOT=/opt/intel/oneapi/compiler/2024.1
ENV CPATH=/opt/intel/oneapi/tbb/2021.12/env/../include:/opt/intel/oneapi/dpl/2022.5/include:/opt/intel/oneapi/dev-utilities/2024.1/include:/opt/intel/oneapi/compiler/2024.1/opt/oclfpga/include
ENV DIAGUTIL_PATH=/opt/intel/oneapi/debugger/2024.1/etc/debugger/sys_check/sys_check.py:/opt/intel/oneapi/compiler/2024.1/etc/compiler/sys_check/sys_check.sh
ENV DPL_ROOT=/opt/intel/oneapi/dpl/2022.5
ENV FPGA_VARS_ARGS=
ENV FPGA_VARS_DIR=/opt/intel/oneapi/compiler/2024.1/opt/oclfpga
ENV GDB_INFO=/opt/intel/oneapi/debugger/2024.1/share/info/
ENV INFOPATH=/opt/intel/oneapi/debugger/2024.1/opt/debugger/lib
ENV INTEL_PYTHONHOME=/opt/intel/oneapi/debugger/2024.1/opt/debugger
ENV INTELFPGAOCLSDKROOT=/opt/intel/oneapi/compiler/2024.1/opt/oclfpga
ENV LD_LIBRARY_PATH=/opt/intel/oneapi/tbb/2021.12/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/dpl/2022.5/lib:/opt/intel/oneapi/debugger/2024.1/opt/debugger/lib:/opt/intel/oneapi/compiler/2024.1/opt/oclfpga/host/linux64/lib:/opt/intel/oneapi/compiler/2024.1/opt/compiler/lib:/opt/intel/oneapi/compiler/2024.1/lib:/lib64:/usr/lib64:/usr/local/lib64:/lib:/usr/lib:/usr/local/lib:
ENV LIBRARY_PATH=/opt/intel/oneapi/tbb/2021.12/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/dpl/2022.5/lib:/opt/intel/oneapi/compiler/2024.1/lib:/lib64:/usr/lib64:/usr/local/lib64:/lib:/usr/lib:/usr/local/lib
ENV MANPATH=/opt/intel/oneapi/debugger/2024.1/share/man:/opt/intel/oneapi/compiler/2024.1/share/man
ENV NLSPATH=/opt/intel/oneapi/compiler/2024.1/lib/compiler/locale/%l_%t/%N
ENV OCL_ICD_FILENAMES=libintelocl_emu.so:libalteracl.so:/opt/intel/oneapi/compiler/2024.1/lib/libintelocl.so
ENV ONEAPI_ROOT=/opt/intel/oneapi
ENV PATH=/opt/intel/oneapi/dev-utilities/2024.1/bin:/opt/intel/oneapi/debugger/2024.1/opt/debugger/bin:/opt/intel/oneapi/compiler/2024.1/opt/oclfpga/bin:/opt/intel/oneapi/compiler/2024.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PKG_CONFIG_PATH=/opt/intel/oneapi/tbb/2021.12/env/../lib/pkgconfig:/opt/intel/oneapi/dpl/2022.5/lib/pkgconfig:/opt/intel/oneapi/compiler/2024.1/lib/pkgconfig
ENV SETVARS_COMPLETED=1
ENV TBBROOT=/opt/intel/oneapi/tbb/2021.12/env/..

ENV CCACHE_BASEDIR=/home/runner/
ENV CCACHE_DIR=/home/runner/.ccache
ENV CCACHE_COMPRESS=true
ENV CCACHE_COMPRESSLEVEL=12
ENV CCACHE_MAXSIZE=75M
ENV GNUMAKEFLAGS="-j4 --no-print-directory --output-sync=target"
