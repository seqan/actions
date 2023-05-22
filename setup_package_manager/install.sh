#!/usr/bin/env bash
set -Eeuo pipefail

install_via_brew()
{
    brew_package_name="$1" # llvm@15
    package_name=$(echo $brew_package_name | awk -F '@' '{print $1; }') # llvm

    # General idea:
    # `brew list --versions` returns 1 if package is installed, and 0 otherwise. By combining it with some other command
    # via `&&`, we can run the second command depending on whether the package is installed.
    # package_name: The package name without a version, e.g. "ccache" and "gcc".
    # brew_package_name: The package followed by an optional version, e.g. "ccache" and "gcc@11".
    # `--force-bottle` will cause brew to use precompiled binaries. Sometimes brew likes to build compilers from scratch.

    # If the package is installed, we unlink the package. brew unlink does not take a version.
    brew list --versions $brew_package_name && \
        brew unlink $package_name \
    || true

    # If the package is installed, we upgrade. Otherwise, we install it.
    brew list --versions $brew_package_name && \
        brew upgrade --force-bottle $brew_package_name \
    || brew install --force-bottle --overwrite $brew_package_name

    # We link the package, i.e. we add symlinks into /usr/local/bin. They requested version of the package should superseed
    # other installed versions (`--overwrite`). For example, when requesting gcc@10 while gcc@11 is already installed and
    # linked, we want to overwrite those links and use gcc@10 instead.
    brew link --overwrite $brew_package_name

    # brew's llvm packages do not create symlinks as they might interfere with Apple's clang installation.
    # Hence, we need to do it explicitly.
    if [ "$package_name" == "llvm" ] && [[ $# -eq 2 ]]; then
        install_prefix=$(brew --prefix $brew_package_name)/bin
        ln -s $install_prefix/clang++ $install_prefix/clang++-$2 || true
        echo "$install_prefix" >> $GITHUB_PATH
    fi
}

if [ "$RUNNER_OS" == "Linux" ]; then
    # gcc-13 -> g++-13
    for ARG in "$@"; do
        sudo apt-get install --yes $(echo ${ARG/gcc/g++})
    done
elif [ "$RUNNER_OS" == "macOS" ]; then
    export HOMEBREW_NO_INSTALL_CLEANUP=1 # Do not run brew cleanup automatically.
    export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 # Do not automatically update packages.

    for ARG in "$@"; do
        # clang-15 -> llvm@15, gcc-13 -> gcc@13
        if [[ $ARG == clang* || $ARG == gcc* ]]; then
            ARG=$(echo ${ARG/clang/llvm} | awk -F '-' '{print $1"@"$2}')
        fi
        install_via_brew $ARG
    done
else
    echo "OS ${$RUNNER_OS} is not supported"
    exit 1
fi
