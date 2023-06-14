#!/usr/bin/env bash
set -Eeuo pipefail

# Replace Microsofts repository with some other mirror, because azure is sometimes down.
sudo sed -i 's@azure.archive.ubuntu.com@mirror.enzu.com@' /etc/apt/sources.list
sudo add-apt-repository --no-update --yes "deb http://mirror.enzu.com/ubuntu/ jammy-updates main restricted universe multiverse"
sudo add-apt-repository --no-update --yes ppa:ubuntu-toolchain-r/ppa
sudo add-apt-repository --no-update --yes ppa:ubuntu-toolchain-r/test
wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | sudo tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc
sudo add-apt-repository --no-update --yes "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-16 main"
sudo add-apt-repository --no-update --yes "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy main"
sudo apt-get update
