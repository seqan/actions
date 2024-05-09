#!/bin/bash -l
set -Eeuxo pipefail

INTEL_VERSION=$1

ln -fs /opt/intel/oneapi/compiler/${INTEL_VERSION}/bin/icx /usr/bin/cc
ln -fs /opt/intel/oneapi/compiler/${INTEL_VERSION}/bin/icpx /usr/bin/c++
ln -fs /opt/intel/oneapi/compiler/${INTEL_VERSION}/bin/compiler/llvm-ar /usr/bin/ar
ln -fs /opt/intel/oneapi/compiler/${INTEL_VERSION}/bin/compiler/lld /usr/bin/ld
ln -fs /opt/intel/oneapi/compiler/${INTEL_VERSION}/bin/compiler/llvm-nm /usr/bin/nm
ln -fs /opt/intel/oneapi/compiler/${INTEL_VERSION}/bin/compiler/llvm-ranlib /usr/bin/ranlib
