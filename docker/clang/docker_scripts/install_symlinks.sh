#!/bin/bash -l
set -Eeuxo pipefail

CLANG_VERSION=$1

ln -fs /usr/bin/llvm-as-${CLANG_VERSION} /usr/bin/as
ln -fs /usr/bin/llvm-ar-${CLANG_VERSION} /usr/bin/ar
ln -fs /usr/bin/ld.lld-${CLANG_VERSION} /usr/bin/ld
ln -fs /usr/bin/llvm-nm-${CLANG_VERSION} /usr/bin/nm
ln -fs /usr/bin/llvm-ranlib-${CLANG_VERSION} /usr/bin/ranlib
ln -fs /usr/bin/clang /usr/bin/cc
ln -fs /usr/bin/clang++ /usr/bin/c++
