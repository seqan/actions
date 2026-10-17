#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuo pipefail

if [[ -n "${SDKROOT:-}" ]]; then
    echo "SDKROOT=${SDKROOT}" >> "${GITHUB_ENV}"
    exit 0
fi

probe=$(mktemp -d "${RUNNER_TEMP}/compiler-sdk.XXXXXX")
trap 'rm -rf "${probe}"' EXIT
read -r -a flags <<< "-x c++ ${LDFLAGS:-}"

# Check both Mach-header compatibility and linking against the SDK.
cat > "${probe}/check.cpp" <<'CPP'
#include <mach/mach.h>
#include <sys/sysctl.h>
#include <vector>
int main() { return 0; }
CPP

for sdk in "$(xcrun --sdk macosx --show-sdk-path 2>/dev/null || true)" \
           "$("${CC}" -print-sysroot 2>/dev/null || true)" \
           /Library/Developer/CommandLineTools/SDKs/MacOSX*.sdk \
           /Applications/*.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX*.sdk; do
    [[ -d "${sdk}" ]] || continue
    if "${CXX}" -isysroot "${sdk}" "${flags[@]}" -o "${probe}/check" - < "${probe}/check.cpp" > "${probe}/log" 2>&1; then
        echo "SDKROOT=${sdk}" >> "${GITHUB_ENV}"
        echo "Selected SDK: ${sdk}"
        exit 0
    fi
    echo "::group::Rejected SDK: ${sdk}"
    cat "${probe}/log"
    echo "::endgroup::"
done

echo "::error::No installed macOS SDK passed the ${CXX} compile/link probe. Install a compatible SDK or choose another compiler; set SDKROOT to select an SDK explicitly."
exit 1
