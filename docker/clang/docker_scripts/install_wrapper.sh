#!/bin/bash -l
set -Eeuxo pipefail

CLANG_VERSION=$1

mv /docker_scripts/clang /usr/bin/clang
sed -i "s/LLVMVERSION/${CLANG_VERSION}/g" /usr/bin/clang

mv /docker_scripts/clang++ /usr/bin/clang++
sed -i "s/LLVMVERSION/${CLANG_VERSION}/g" /usr/bin/clang++
