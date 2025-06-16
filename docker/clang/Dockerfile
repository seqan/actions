# syntax=docker/dockerfile:1

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

FROM seqan-actions-base

ARG CLANG_VERSION

COPY docker_scripts /docker_scripts

RUN /docker_scripts/install_packages.sh ${CLANG_VERSION} && \
    /docker_scripts/install_wrapper.sh ${CLANG_VERSION} && \
    /docker_scripts/install_symlinks.sh ${CLANG_VERSION} && \
    /docker_scripts/show_versions.sh

ENV CC=clang
ENV CXX=clang++
ENV OMP_TOOL_LIBRARIES=/usr/lib/llvm-${CLANG_VERSION}/lib/libarcher.so
