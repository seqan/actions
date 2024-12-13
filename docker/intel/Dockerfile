# syntax=docker/dockerfile:1

# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

FROM debian:unstable-slim

ARG INTEL_VERSION=2025.0
ARG SDE_DIR="/sde"

SHELL ["/bin/bash", "-Eeuxo", "pipefail", "-c"]

COPY docker_scripts /docker_scripts
COPY --from=common install_common_packages.sh /docker_scripts/
COPY --from=common install_sde.sh /docker_scripts/
COPY --from=common show_versions.sh /docker_scripts/

RUN /docker_scripts/install_common_packages.sh && \
    /docker_scripts/install_packages.sh ${INTEL_VERSION} && \
    /docker_scripts/install_symlinks.sh ${INTEL_VERSION} && \
    /docker_scripts/install_sde.sh ${SDE_DIR} && \
    /docker_scripts/show_versions.sh

ENV CC=icx
ENV CXX=icpx

ENV CMAKE_PREFIX_PATH=/opt/intel/oneapi/tbb/2022.0/env/..:/opt/intel/oneapi/dpl/2022.7/lib/cmake/oneDPL:/opt/intel/oneapi/compiler/2025.0
ENV CMPLR_ROOT=/opt/intel/oneapi/compiler/2025.0
ENV CPATH=/opt/intel/oneapi/umf/0.9/include:/opt/intel/oneapi/tbb/2022.0/env/../include:/opt/intel/oneapi/dpl/2022.7/include:/opt/intel/oneapi/dev-utilities/2025.0/include
ENV DIAGUTIL_PATH=/opt/intel/oneapi/compiler/2025.0/etc/compiler/sys_check/sys_check.sh
ENV DPL_ROOT=/opt/intel/oneapi/dpl/2022.7
ENV GDB_INFO=/opt/intel/oneapi/debugger/2025.0/share/info/
ENV INFOPATH=/opt/intel/oneapi/debugger/2025.0/share/info
ENV INTEL_PYTHONHOME=/opt/intel/oneapi/debugger/2025.0/opt/debugger
ENV LD_LIBRARY_PATH=/opt/intel/oneapi/tcm/1.2/lib:/opt/intel/oneapi/umf/0.9/lib:/opt/intel/oneapi/tbb/2022.0/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/debugger/2025.0/opt/debugger/lib:/opt/intel/oneapi/compiler/2025.0/opt/compiler/lib:/opt/intel/oneapi/compiler/2025.0/lib
ENV LIBRARY_PATH=/opt/intel/oneapi/tcm/1.2/lib:/opt/intel/oneapi/umf/0.9/lib:/opt/intel/oneapi/tbb/2022.0/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/compiler/2025.0/lib
ENV MANPATH=/opt/intel/oneapi/debugger/2025.0/share/man:/opt/intel/oneapi/compiler/2025.0/share/man:
ENV NLSPATH=/opt/intel/oneapi/compiler/2025.0/lib/compiler/locale/%l_%t/%N
ENV OCL_ICD_FILENAMES=/opt/intel/oneapi/compiler/2025.0/lib/libintelocl.so
ENV ONEAPI_ROOT=/opt/intel/oneapi
ENV PATH=${SDE_DIR}:/opt/intel/oneapi/dev-utilities/2025.0/bin:/opt/intel/oneapi/debugger/2025.0/opt/debugger/bin:/opt/intel/oneapi/compiler/2025.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PKG_CONFIG_PATH=/opt/intel/oneapi/tbb/2022.0/env/../lib/pkgconfig:/opt/intel/oneapi/dpl/2022.7/lib/pkgconfig:/opt/intel/oneapi/compiler/2025.0/lib/pkgconfig
ENV SETVARS_COMPLETED=1
ENV TBBROOT=/opt/intel/oneapi/tbb/2022.0/env/..
ENV TCM_ROOT=/opt/intel/oneapi/tcm/1.2
ENV UMF_ROOT=/opt/intel/oneapi/umf/0.9

ENV CCACHE_BASEDIR=/home/runner/
ENV CCACHE_DIR=/home/runner/.ccache
ENV CCACHE_COMPRESS=true
ENV CCACHE_COMPRESSLEVEL=12
ENV CCACHE_MAXSIZE=75M
ENV CCACHE_COMPILERCHECK=content
ENV CTEST_NO_TESTS_ACTION=error
ENV CTEST_OUTPUT_ON_FAILURE=1
ENV CPM_SOURCE_CACHE=/home/runner/.cpm
ENV GNUMAKEFLAGS="-j4 --no-print-directory --output-sync=target"
ENV MAKEFLAGS="-j4 --no-print-directory --output-sync=target"
