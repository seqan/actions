# syntax=docker/dockerfile:1

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

FROM seqan-actions-base

# 2025.0 is the last version that supports FPGAs (intel-oneapi-compiler-fpga).
ARG INTEL_VERSION=2025.0

COPY docker_scripts /docker_scripts

RUN /docker_scripts/install_packages.sh ${INTEL_VERSION} && \
    /docker_scripts/install_symlinks.sh ${INTEL_VERSION} && \
    /docker_scripts/show_versions.sh

ENV CC=icx
ENV CXX=icpx

ENV ACL_BOARD_VENDOR_PATH=/opt/Intel/OpenCLFPGA/oneAPI/Boards
ENV CMAKE_PREFIX_PATH=/opt/intel/oneapi/tbb/2022.0/env/..:/opt/intel/oneapi/dpl/2022.7/lib/cmake/oneDPL:/opt/intel/oneapi/compiler/2025.0
ENV CMPLR_ROOT=/opt/intel/oneapi/compiler/2025.0
ENV CPATH=/opt/intel/oneapi/umf/0.9/include:/opt/intel/oneapi/tbb/2022.0/env/../include:/opt/intel/oneapi/dpl/2022.7/include:/opt/intel/oneapi/dev-utilities/2025.0/include:/opt/intel/oneapi/compiler/2025.0/opt/oclfpga/include
ENV DIAGUTIL_PATH=/opt/intel/oneapi/compiler/2025.0/etc/compiler/sys_check/sys_check.sh
ENV DPL_ROOT=/opt/intel/oneapi/dpl/2022.7
ENV FPGA_VARS_ARGS=
ENV FPGA_VARS_DIR=/opt/intel/oneapi/compiler/2025.0/opt/oclfpga
ENV GDB_INFO=/opt/intel/oneapi/debugger/2025.0/share/info/
ENV INFOPATH=/opt/intel/oneapi/debugger/2025.0/share/info
ENV INTEL_PYTHONHOME=/opt/intel/oneapi/debugger/2025.0/opt/debugger
ENV INTELFPGAOCLSDKROOT=/opt/intel/oneapi/compiler/2025.0/opt/oclfpga
ENV LD_LIBRARY_PATH=/opt/intel/oneapi/compiler/2025.0/opt/oclfpga/host/linux64/lib:/opt/intel/oneapi/tcm/1.2/lib:/opt/intel/oneapi/umf/0.9/lib:/opt/intel/oneapi/tbb/2022.0/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/debugger/2025.0/opt/debugger/lib:/opt/intel/oneapi/compiler/2025.0/opt/compiler/lib:/opt/intel/oneapi/compiler/2025.0/lib
ENV LIBRARY_PATH=/opt/intel/oneapi/tcm/1.2/lib:/opt/intel/oneapi/umf/0.9/lib:/opt/intel/oneapi/tbb/2022.0/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/compiler/2025.0/lib
ENV MANPATH=/opt/intel/oneapi/debugger/2025.0/share/man:/opt/intel/oneapi/compiler/2025.0/share/man:
ENV NLSPATH=/opt/intel/oneapi/compiler/2025.0/lib/compiler/locale/%l_%t/%N
ENV OCL_ICD_FILENAMES=libintelocl_emu.so:libalteracl.so:/opt/intel/oneapi/compiler/2025.0/lib/libintelocl.so
ENV ONEAPI_ROOT=/opt/intel/oneapi
ENV PATH=/opt/intel/oneapi/compiler/2025.0/opt/oclfpga/bin:/opt/intel/oneapi/dev-utilities/2025.0/bin:/opt/intel/oneapi/debugger/2025.0/opt/debugger/bin:/opt/intel/oneapi/compiler/2025.0/bin:${PATH}
ENV PKG_CONFIG_PATH=/opt/intel/oneapi/tbb/2022.0/env/../lib/pkgconfig:/opt/intel/oneapi/dpl/2022.7/lib/pkgconfig:/opt/intel/oneapi/compiler/2025.0/lib/pkgconfig
ENV SETVARS_COMPLETED=1
ENV TBBROOT=/opt/intel/oneapi/tbb/2022.0/env/..
ENV TCM_ROOT=/opt/intel/oneapi/tcm/1.2
ENV UMF_ROOT=/opt/intel/oneapi/umf/0.9
