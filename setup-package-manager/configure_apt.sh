#!/usr/bin/env bash
set -Eeuo pipefail

# Contains, e.g., VERSION_CODENAME
source /etc/os-release

echo 'Acquire::Retries "10";' | sudo tee /etc/apt/apt.conf.d/80-retries
echo 'APT::Get::Assume-Yes "true";' | sudo tee /etc/apt/apt.conf.d/80-assume-yes
echo 'quiet "1";' | sudo tee /etc/apt/apt.conf.d/80-quiet

retry_command ()
{
    for i in 1 2 3 4 5; do
        if [[ $i -eq 5 ]]; then
            "$@"
        else
            "$@" && break || sleep $((i * 5))
        fi
    done
}

# Replace Microsofts repository with some other mirror, because azure is sometimes down.
retry_command sudo sed -i 's@azure.archive.ubuntu.com@mirror.enzu.com@' /etc/apt/apt-mirrors.txt

# GCC
retry_command sudo add-apt-repository --no-update --yes ppa:ubuntu-toolchain-r/ppa
retry_command sudo add-apt-repository --no-update --yes ppa:ubuntu-toolchain-r/test

# Clang
retry_command wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | sudo tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc
retry_command sudo add-apt-repository --no-update --yes "deb http://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME}-15 main"
retry_command sudo add-apt-repository --no-update --yes "deb http://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME}-16 main"
retry_command sudo add-apt-repository --no-update --yes "deb http://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME}-17 main"
retry_command sudo add-apt-repository --no-update --yes "deb http://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME} main"

# Intel
retry_command wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | sudo tee /etc/apt/trusted.gpg.d/apt.repos.intel.com.asc
retry_command sudo add-apt-repository --no-update --yes "deb https://apt.repos.intel.com/oneapi all main"

retry_command sudo apt-get update --yes
