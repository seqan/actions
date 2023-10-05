#!/usr/bin/env bash
set -Eeuo pipefail

# Contains, e.g., VERSION_CODENAME
source /etc/os-release

# Replace Microsofts repository with some other mirror, because azure is sometimes down.
sudo sed -i 's@azure.archive.ubuntu.com@mirror.enzu.com@' /etc/apt/apt-mirrors.txt

# GCC
sudo add-apt-repository --no-update --yes ppa:ubuntu-toolchain-r/ppa
sudo add-apt-repository --no-update --yes ppa:ubuntu-toolchain-r/test

# Clang
wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | sudo tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc
sudo add-apt-repository --no-update --yes "deb http://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME}-15 main"
sudo add-apt-repository --no-update --yes "deb http://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME}-16 main"
sudo add-apt-repository --no-update --yes "deb http://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME}-17 main"
sudo add-apt-repository --no-update --yes "deb http://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME} main"

# Intel
wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | sudo tee /etc/apt/trusted.gpg.d/apt.repos.intel.com.asc
sudo add-apt-repository --no-update --yes "deb https://apt.repos.intel.com/oneapi all main"

sudo apt-get update
