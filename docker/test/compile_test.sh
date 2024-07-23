#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

set -Eeuo pipefail

TMP_TEST_DIR=$(mktemp --directory)
cd ${TMP_TEST_DIR}

cat > hello_world.cpp <<- EOM
#include <string>

std::string hello_world_short()
{
    return "Hello!";
}

std::string hello_world_long()
{
    return "Hello World! This is a rather long string.";
}
EOM

cat > main.cpp <<- EOM
#include <iostream>
#include <string>
#include <string_view>

#if defined(__cpp_if_consteval) && __cpp_if_consteval >= 202106L
constexpr std::string_view is_consteval()
{
    if consteval
    {
        return "consteval";
    }
    else
    {
        return "not consteval";
    }
}
#else
constexpr std::string_view is_consteval()
{
    return "if consteval not supported";
}
#endif

std::string hello_world_short();
std::string hello_world_long();

int main()
{
    std::cout << "hello_world_short(): " << hello_world_short() << '\n';
    std::cout << "hello_world_long(): " << hello_world_long() << '\n';

    std::string_view not_constant_evaluated = is_consteval();
    constexpr std::string_view constant_evaluated = is_consteval();

    std::cout << "is_consteval(): " << not_constant_evaluated << '\n';
    std::cout << "is_consteval(): " << constant_evaluated << '\n';

    return 0;
}
EOM

if $CXX -std=c++23 -xc++ -E - </dev/null &>/dev/null; then
    STD_OPTION="-std=c++23"
else
    STD_OPTION="-std=c++20"
fi
echo "Using $CXX with $STD_OPTION"

$CXX ${STD_OPTION} -flto=auto -o test main.cpp hello_world.cpp
${TMP_TEST_DIR}/test > actual.cout 2> actual.cerr

cat > expected.cout <<- EOM
hello_world_short(): Hello!
hello_world_long(): Hello World! This is a rather long string.
is_consteval(): not consteval
is_consteval(): consteval
EOM

cat > expected.cout2 <<- EOM
hello_world_short(): Hello!
hello_world_long(): Hello World! This is a rather long string.
is_consteval(): if consteval not supported
is_consteval(): if consteval not supported
EOM

diff expected.cout actual.cout || diff expected.cout2 actual.cout
test -f actual.cerr
! test -s actual.cerr
