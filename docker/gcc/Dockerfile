# syntax=docker/dockerfile:1

FROM debian:unstable-slim

ARG GCC_VERSION

SHELL ["/bin/bash", "-Eeuxo", "pipefail", "-c"]

COPY docker_scripts /docker_scripts

RUN /docker_scripts/install_packages.sh ${GCC_VERSION} && \
    /docker_scripts/install_symlinks.sh ${GCC_VERSION}

ENV CC=gcc-${GCC_VERSION}
ENV CXX=g++-${GCC_VERSION}

ENV CCACHE_BASEDIR=/home/runner/
ENV CCACHE_DIR=/home/runner/.ccache
ENV CCACHE_COMPRESS=true
ENV CCACHE_COMPRESSLEVEL=12
ENV CCACHE_MAXSIZE=75M
