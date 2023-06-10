#!/usr/bin/env bash
set -Eeuo pipefail

# Replace Microsofts repository with some other mirror, because azure is sometimes down.
sudo sed -i 's@azure.archive.ubuntu.com@mirror.enzu.com@' /etc/apt/sources.list
sudo add-apt-repository --no-update --yes ppa:ubuntu-toolchain-r/ppa
sudo add-apt-repository --no-update --yes ppa:ubuntu-toolchain-r/test
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
sudo add-apt-repository --no-update --yes "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy main"
sudo apt-get update
