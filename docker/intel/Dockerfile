# syntax=docker/dockerfile:1

# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

FROM debian:unstable-slim

ARG INTEL_VERSION=2024.2

SHELL ["/bin/bash", "-Eeuxo", "pipefail", "-c"]

COPY docker_scripts /docker_scripts
COPY --from=common install_common_packages.sh /docker_scripts/

RUN /docker_scripts/install_common_packages.sh && \
    /docker_scripts/install_packages.sh ${INTEL_VERSION} && \
    /docker_scripts/install_symlinks.sh ${INTEL_VERSION}

ENV CC=icx
ENV CXX=icpx

ENV CMAKE_PREFIX_PATH=/opt/intel/oneapi/tbb/2021.13/env/..:/opt/intel/oneapi/dpl/2022.6/lib/cmake/oneDPL:/opt/intel/oneapi/compiler/2024.2
ENV CMPLR_ROOT=/opt/intel/oneapi/compiler/2024.2
ENV CPATH=/opt/intel/oneapi/tbb/2021.13/env/../include:/opt/intel/oneapi/dpl/2022.6/include:/opt/intel/oneapi/dev-utilities/2024.2/include
ENV DIAGUTIL_PATH=/opt/intel/oneapi/debugger/2024.2/etc/debugger/sys_check/sys_check.py:/opt/intel/oneapi/compiler/2024.2/etc/compiler/sys_check/sys_check.sh
ENV DPL_ROOT=/opt/intel/oneapi/dpl/2022.6
ENV GDB_INFO=/opt/intel/oneapi/debugger/2024.2/share/info/
ENV INFOPATH=/opt/intel/oneapi/debugger/2024.2/share/info
ENV INTEL_PYTHONHOME=/opt/intel/oneapi/debugger/2024.2/opt/debugger
ENV LD_LIBRARY_PATH=/opt/intel/oneapi/tbb/2021.13/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/dpl/2022.6/lib:/opt/intel/oneapi/debugger/2024.2/opt/debugger/lib:/opt/intel/oneapi/compiler/2024.2/opt/compiler/lib:/opt/intel/oneapi/compiler/2024.2/lib
ENV LIBRARY_PATH=/opt/intel/oneapi/tbb/2021.13/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/dpl/2022.6/lib:/opt/intel/oneapi/compiler/2024.2/lib
ENV MANPATH=/opt/intel/oneapi/debugger/2024.2/share/man:/opt/intel/oneapi/compiler/2024.2/share/man:
ENV NLSPATH=/opt/intel/oneapi/compiler/2024.2/lib/compiler/locale/%l_%t/%N
ENV OCL_ICD_FILENAMES=/opt/intel/oneapi/compiler/2024.2/lib/libintelocl.so
ENV ONEAPI_ROOT=/opt/intel/oneapi
ENV PATH=/opt/intel/oneapi/dev-utilities/2024.2/bin:/opt/intel/oneapi/debugger/2024.2/opt/debugger/bin:/opt/intel/oneapi/compiler/2024.2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PKG_CONFIG_PATH=/opt/intel/oneapi/tbb/2021.13/env/../lib/pkgconfig:/opt/intel/oneapi/dpl/2022.6/lib/pkgconfig:/opt/intel/oneapi/compiler/2024.2/lib/pkgconfig
ENV SETVARS_COMPLETED=1
ENV TBBROOT=/opt/intel/oneapi/tbb/2021.13/env/..

ENV CCACHE_BASEDIR=/home/runner/
ENV CCACHE_DIR=/home/runner/.ccache
ENV CCACHE_COMPRESS=true
ENV CCACHE_COMPRESSLEVEL=12
ENV CCACHE_MAXSIZE=75M
ENV GNUMAKEFLAGS="-j4 --no-print-directory --output-sync=target"
ENV MAKEFLAGS="-j4 --no-print-directory --output-sync=target"
