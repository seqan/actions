# syntax=docker/dockerfile:1

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

# 20 is just a default value in case no version is provided
ARG CLANG_VERSION=20
FROM ghcr.io/seqan/clang-${CLANG_VERSION}

ARG CLANG_VERSION
ARG IWYU_VERSION

COPY docker_scripts /docker_scripts

RUN /docker_scripts/install_iwyu.sh ${CLANG_VERSION} ${IWYU_VERSION}
