# syntax=docker/dockerfile:1

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

FROM debian:unstable-slim

ARG SDE_DIR="/sde"
ENV PATH=${SDE_DIR}:${PATH}

ENV CCACHE_BASEDIR=/home/runner/
ENV CCACHE_COMPILERCHECK=content
ENV CCACHE_COMPRESS=true
ENV CCACHE_COMPRESSLEVEL=12
ENV CCACHE_DIR=/home/runner/.ccache
ENV CCACHE_MAXSIZE=75M

ENV CTEST_NO_TESTS_ACTION=error
ENV CTEST_OUTPUT_ON_FAILURE=1

ENV CPM_SOURCE_CACHE=/home/runner/.cpm

ENV DEBIAN_FRONTEND=noninteractive

ENV GNUMAKEFLAGS="-j4 --no-print-directory --output-sync=target"
ENV MAKEFLAGS="-j4 --no-print-directory --output-sync=target"

SHELL ["/bin/bash", "-Eeuxo", "pipefail", "-c"]

COPY common /docker_scripts

RUN /docker_scripts/check_available_threads.sh && \
    /docker_scripts/install_common_packages.sh && \
    /docker_scripts/install_sde.sh ${SDE_DIR}

