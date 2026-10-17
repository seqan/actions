#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuo pipefail

case "$1" in
    clang-latest)
        COMPILER="clang-23"
        ;;
    clang-second-latest)
        COMPILER="clang-22"
        ;;
    clang-third-latest)
        COMPILER="clang-21"
        ;;
    *)
        COMPILER="$1"
        ;;
esac

install "${COMPILER}"
echo "CC=${COMPILER}" >> "${GITHUB_ENV}"
echo "CXX=${COMPILER/clang/clang++}" >> "${GITHUB_ENV}"
CLANG_VERSION="${COMPILER:6}"

if [[ "${RUNNER_OS}" == "Linux" ]]; then
    install "lld-${CLANG_VERSION}" "libc++-${CLANG_VERSION}-dev" "libc++abi-${CLANG_VERSION}-dev" "libomp-${CLANG_VERSION}-dev" "libclang-${CLANG_VERSION}-dev"
    echo "OMP_TOOL_LIBRARIES=/usr/lib/llvm-${CLANG_VERSION}/lib/libarcher.so" >> "${GITHUB_ENV}"
    sudo ln -fs "/usr/bin/llvm-as-${CLANG_VERSION}" /usr/bin/as
    sudo ln -fs "/usr/bin/llvm-ar-${CLANG_VERSION}" /usr/bin/ar
    sudo ln -fs "/usr/bin/ld.lld-${CLANG_VERSION}" /usr/bin/ld
    sudo ln -fs "/usr/bin/llvm-nm-${CLANG_VERSION}" /usr/bin/nm
    sudo ln -fs "/usr/bin/llvm-ranlib-${CLANG_VERSION}" /usr/bin/ranlib
    if [[ ! -e "/usr/lib/llvm-${CLANG_VERSION}/lib/libclang-${CLANG_VERSION}.so.1" ]]; then
        sudo ln -fs "/usr/lib/llvm-${CLANG_VERSION}/lib/libclang-${CLANG_VERSION}.so" "/usr/lib/llvm-${CLANG_VERSION}/lib/libclang-${CLANG_VERSION}.so.1"
    fi
elif [[ "${RUNNER_OS}" == "macOS" ]]; then
    INSTALL_PREFIX=$(brew --prefix "llvm@${CLANG_VERSION}")
    # https://github.com/llvm/llvm-project/issues/92121
    if [[ "${CLANG_VERSION}" -gt 18 ]]; then
        echo "LDFLAGS=-L${INSTALL_PREFIX}/lib/c++ -L${INSTALL_PREFIX}/lib/unwind -lunwind -Wl,-rpath,${INSTALL_PREFIX}/lib/c++ -Wl,-rpath,${INSTALL_PREFIX}/lib/unwind" >> "${GITHUB_ENV}"
    elif [[ "${CLANG_VERSION}" -gt 17 ]]; then
        echo "LDFLAGS=-L${INSTALL_PREFIX}/lib/c++ -L${INSTALL_PREFIX}/lib/ -lunwind -Wl,-rpath,${INSTALL_PREFIX}/lib/c++ -Wl,-rpath,${INSTALL_PREFIX}/lib/" >> "${GITHUB_ENV}"
    else
        echo "LDFLAGS=-L${INSTALL_PREFIX}/lib/c++ -Wl,-rpath,${INSTALL_PREFIX}/lib/c++" >> "${GITHUB_ENV}"
    fi
    sudo ln -fs "${INSTALL_PREFIX}/bin/clang++" "${INSTALL_PREFIX}/bin/clang++-${CLANG_VERSION}"
    sudo ln -fs "${INSTALL_PREFIX}/bin/llvm-ar" "${INSTALL_PREFIX}/bin/ar"
    sudo ln -fs "${INSTALL_PREFIX}/bin/llvm-as" "${INSTALL_PREFIX}/bin/as"
    sudo ln -fs "${INSTALL_PREFIX}/bin/llvm-nm" "${INSTALL_PREFIX}/bin/nm"
    sudo ln -fs "${INSTALL_PREFIX}/bin/llvm-ranlib" "${INSTALL_PREFIX}/bin/ranlib"
    echo "${INSTALL_PREFIX}/bin" >> "${GITHUB_PATH}"
    install lld
    install libomp
    LIBOMP_PREFIX=$(brew --prefix libomp)
    echo "OpenMP_ROOT=${LIBOMP_PREFIX}" >> "${GITHUB_ENV}"
fi
