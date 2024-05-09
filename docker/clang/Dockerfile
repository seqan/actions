# syntax=docker/dockerfile:1

FROM debian:unstable-slim

ARG CLANG_VERSION

SHELL ["/bin/bash", "-Eeuxo", "pipefail", "-c"]

COPY docker_scripts /docker_scripts

RUN /docker_scripts/install_packages.sh ${CLANG_VERSION} && \
    /docker_scripts/install_wrapper.sh ${CLANG_VERSION} && \
    /docker_scripts/install_symlinks.sh ${CLANG_VERSION}

ENV CC=clang
ENV CXX=clang++
ENV OMP_TOOL_LIBRARIES=/usr/lib/llvm-${CLANG_VERSION}/lib/libarcher.so

ENV CCACHE_BASEDIR=/home/runner/
ENV CCACHE_DIR=/home/runner/.ccache
ENV CCACHE_COMPRESS=true
ENV CCACHE_COMPRESSLEVEL=12
ENV CCACHE_MAXSIZE=75M
