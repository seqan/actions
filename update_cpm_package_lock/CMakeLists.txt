# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: CC-BY-4.0

cmake_minimum_required (VERSION 3.25...3.30)

project (update_cpm_package_lock
         VERSION 1.0.0
         DESCRIPTION "Updates packages in a CPM package-lock file."
         HOMEPAGE_URL "https://github.com/seqan/actions"
         LANGUAGES NONE
)

# Branch annotations
# If `GIT_TAG` or `URL` is used to point to a commit, e.g.,
#     `GIT_TAG 28e15a2d7dd1f3acd3803ca1ad5e5d4eaad6190d`
# or
#     `URL https://github.com/github/codeql/archive/74ef91649b706b23a4a9d70085129acca2987fff.zip`
# it is not (generally and reliably) possible to tell which branch should be queried for the latest commit.
# You can add a comment in the form of `# <branch>` to set the referenced branch, e.g.,
#     `GIT_TAG 28e15a2d7dd1f3acd3803ca1ad5e5d4eaad6190d # main`
# or
#     `URL https://github.com/github/codeql/archive/74ef91649b706b23a4a9d70085129acca2987fff.zip # main`

# Tags
# When using `GIT_TAG` or `URL` to point to a tag, e.g.,
#     `URL https://github.com/github/codeql/archive/refs/tags/codeql-cli/v2.12.0.zip`
# or
#     `GIT_TAG codeql-cli/v2.12.0`
# it is not (generally and reliably) possible to tell what branch should be considered newer.
# This is an open issue.
# In certain circumstances it is possible to use `VERSION` instead.

# Releases
# When using `VERSION`, the repository is queried for the latest release.
# Releases are a feature provided by, e.g., GitHub and not part of git itself. Releases are just tags.

# Supported Platforms
# GitHub
#    GitHub's REST API is used to query for newer commits and versions.

# Supported CPM Inputs
# * VERSION
# * GIT_TAG (if it points to a commit and is annotated, see Branch annotations)
# * URL (if it points to a branch, or if it points to a commit and is annotated, see Branch annotations),
#       See also https://docs.github.com/en/repositories/working-with-files/using-files/downloading-source-code-archives#source-code-archive-urls

# Inputs:
# PACKAGE_LOCK
#    Path to package-lock.cmake
# IGNORED_PACKAGES:
#    List of packages to ignore.
#    Must have the format "owner/repo"
#    Multiple inputs must be separated by ";" (CMake's list separator).
#    To avoid interpretation of the ";" by the shell, quotes or backslash-escape must be used.
#    Examples:
#      -DIGNORED_PACKAGES=seqan/seqan\;seqan/seqan3
#      "-DIGNORED_PACKAGES=seqan/seqan;seqan/seqan3"
#      '-DIGNORED_PACKAGES=seqan/seqan;seqan/seqan3'
#      -DIGNORED_PACKAGES=seqan/seqan

# ----------------------------------------------------------------------------
# Setup
# ----------------------------------------------------------------------------

if (NOT PACKAGE_LOCK)
    message (FATAL_ERROR "Please pass the path to the CPM package lock file: -DPACKAGE_LOCK=<path>")
endif ()
if (NOT EXISTS "${PACKAGE_LOCK}")
    message (FATAL_ERROR "File does not exist: \"${PACKAGE_LOCK}\"")
endif ()
if (NOT IS_READABLE "${PACKAGE_LOCK}")
    message (FATAL_ERROR "File exists, but cannot be read: \"${PACKAGE_LOCK}\"")
endif ()
if (NOT IS_WRITABLE "${PACKAGE_LOCK}")
    message (FATAL_ERROR "File exists, but cannot be written to: \"${PACKAGE_LOCK}\"")
endif ()

file (DOWNLOAD https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/CPM.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/CPM.cmake
)
include (${CMAKE_CURRENT_BINARY_DIR}/CPM.cmake)

file (READ "${PACKAGE_LOCK}" CONTENT)
CPMUsePackageLock ("${PACKAGE_LOCK}")

set (PACKAGE_LIST "")
# cmake-format: off
block (SCOPE_FOR VARIABLES PROPAGATE PACKAGE_LIST)
    set (TMP_PACKAGE_LOCK "${CMAKE_CURRENT_BINARY_DIR}/package-lock.cmake")
    configure_file ("${PACKAGE_LOCK}" "${TMP_PACKAGE_LOCK}")
    file (READ "${TMP_PACKAGE_LOCK}" STR)
    string (REGEX MATCHALL "\\(([^()]+)\\)" PACKAGE_LIST ${STR})
endblock ()
# cmake-format: on

# ----------------------------------------------------------------------------
# Helper functions
# ----------------------------------------------------------------------------

function (replace_if_unique_match old_string new_string output_var input_string)
    string (FIND ${input_string} ${old_string} FIND1)
    string (FIND ${input_string} ${old_string} FIND2 REVERSE)
    if (FIND1 STREQUAL FIND2)
        string (REPLACE "${old_string}" "${new_string}" ${output_var} ${input_string})
    else ()
        message (WARNING "UPDATE FAILED: Found string \"${old_string}\" twice.")
    endif ()
    return (PROPAGATE ${output_var})
endfunction ()

function (check_if_commit repo tag result)
    set (${result} FALSE)
    if (tag)
        string (LENGTH ${tag} TAG_LENGTH)
        if (TAG_LENGTH EQUAL 40)
            set (${result} TRUE)
        else ()
            execute_process (COMMAND "gh" "api" "/repos/${repo}/branches/${tag}"
                             RESULT_VARIABLE IS_BRANCH
                             OUTPUT_QUIET ERROR_QUIET
            )
            if (NOT IS_BRANCH EQUAL 0)
                set (${result} TRUE)
            endif ()
        endif ()
    endif ()
    return (PROPAGATE ${result})
endfunction ()

# ----------------------------------------------------------------------------
# Do the thing
# ----------------------------------------------------------------------------

foreach (PACKAGE ${PACKAGE_LIST})
    set (REPO "")
    set (TAG "")
    set (VERSION "")
    set (BRANCH "")
    set (TAG_IS_COMMIT FALSE)

    if (PACKAGE MATCHES "GITHUB_REPOSITORY +([^ \t\r\n]+)")
        set (REPO "${CMAKE_MATCH_1}")

        if (PACKAGE MATCHES "GIT_TAG +([^ \t\r\n]+)[^#\r\n]*([ #]*)([^ \t\r\n]*)")
            set (TAG "${CMAKE_MATCH_1}")
            set (BRANCH "${CMAKE_MATCH_3}")
        elseif (PACKAGE MATCHES "VERSION +([^ \t\r\n]+)")
            set (VERSION "${CMAKE_MATCH_1}")
        endif ()

        check_if_commit (${REPO} "${TAG}" TAG_IS_COMMIT)
    elseif (PACKAGE MATCHES "URL +([^ \t\r\n]+)([ #]*)([^ \t\r\n]*)")
        set (URL "${CMAKE_MATCH_1}")
        set (BRANCH "${CMAKE_MATCH_3}")

        if (URL MATCHES "https://github.com/([^/]+)/([^/]+)/archive/(.*)")
            set (REPO "${CMAKE_MATCH_1}/${CMAKE_MATCH_2}")
            set (SUBURL "${CMAKE_MATCH_3}")
            if (SUBURL MATCHES "refs/heads/(.*)\.(tar\.gz|zip)")
                set (BRANCH "${CMAKE_MATCH_1}")
            elseif (SUBURL MATCHES "refs/tags/(.*)\.(tar\.gz|zip)")
                set (TAG "${CMAKE_MATCH_1}")
            elseif (SUBURL MATCHES "([a-zA-Z0-9]*)\.(tar\.gz|zip)")
                set (TAG "${CMAKE_MATCH_1}")
                set (TAG_IS_COMMIT TRUE)
            endif ()
        endif ()
    endif ()

    if (NOT REPO)
        continue ()
    endif ()

    if ("${REPO}" IN_LIST IGNORED_PACKAGES)
        message (STATUS "Skipping ${REPO}\n" #
                        "    Ignored package."
        )
        continue ()
    endif ()

    if (VERSION)
        execute_process (COMMAND "gh" "api" "/repos/${REPO}/releases/latest" "-q" ".tag_name"
                         OUTPUT_VARIABLE LATEST_RELEASE
                         OUTPUT_STRIP_TRAILING_WHITESPACE
                         ERROR_VARIABLE ERROR_MESSAGE
                         ERROR_STRIP_TRAILING_WHITESPACE
                         RESULT_VARIABLE RETURN_CODE
        )
        if (RETURN_CODE)
            message (STATUS "[WARNING] Skipping ${REPO}\n" #
                            "    Failed to query latest release: ${ERROR_MESSAGE}"
            )
            continue ()
        endif ()
        if (LATEST_RELEASE MATCHES "[vV]*(.*)")
            set (LATEST_RELEASE "${CMAKE_MATCH_1}")
        else ()
            message (STATUS "[WARNING] Skipping ${REPO}\n" #
                            "    Unknown version string for latest release: \"${LATEST_RELEASE}\""
            )
        endif ()
        if (VERSION STREQUAL LATEST_RELEASE)
            message (STATUS "${REPO} is up-to-date\n" #
                            "    Current release: \"${VERSION}\"\n" #
                            "    Latest release : \"${LATEST_RELEASE}\""
            )
        else ()
            message (STATUS "Updating ${REPO}\n" #
                            "    Current release: \"${VERSION}\"\n" #
                            "    Latest release : \"${LATEST_RELEASE}\""
            )
            replace_if_unique_match ("${VERSION}" "${LATEST_RELEASE}" CONTENT ${CONTENT})
        endif ()
    elseif (BRANCH)
        execute_process (COMMAND "gh" "api" "/repos/${REPO}/branches/${BRANCH}" "-q" ".commit .sha"
                         OUTPUT_VARIABLE LATEST_COMMIT
                         OUTPUT_STRIP_TRAILING_WHITESPACE
                         ERROR_VARIABLE ERROR_MESSAGE
                         ERROR_STRIP_TRAILING_WHITESPACE
                         RESULT_VARIABLE RETURN_CODE
        )
        if (RETURN_CODE)
            message (STATUS "[WARNING] Skipping ${REPO}\n" #
                            "    Failed to query branch ${BRANCH}: ${ERROR_MESSAGE}"
            )
            continue ()
        endif ()
        if (NOT TAG)
            message (STATUS "[WARNING] Skipping ${REPO}\n" #
                            "    Branch: \"${BRANCH}\"\n" #
                            "    URL points to a branch archive. Nothing to update."
            )
        elseif (TAG STREQUAL LATEST_COMMIT)
            message (STATUS "${REPO} is up-to-date\n" #
                            "    Branch: \"${BRANCH}\"\n" #
                            "    Current commit: \"${TAG}\"\n" #
                            "    Latest commit : \"${LATEST_COMMIT}\""
            )
        else ()
            message (STATUS "Updating ${REPO}\n" #
                            "    Branch: \"${BRANCH}\"\n" #
                            "    Current commit: \"${TAG}\"\n" #
                            "    Latest commit : \"${LATEST_COMMIT}\""
            )
            replace_if_unique_match ("${TAG}" "${LATEST_COMMIT}" CONTENT ${CONTENT})
        endif ()
    elseif (TAG AND NOT TAG_IS_COMMIT)
        message (STATUS "[WARNING] Skipping ${REPO}\n" #
                        "    Tag: \"${TAG}\"\n" #
                        "    Current tag/URL points to a tag.\n" #
                        "    It is not generally possible to tell what would be considered a newer tag."
        )
    elseif (TAG AND TAG_IS_COMMIT)
        message (STATUS "[WARNING] Skipping ${REPO}\n" #
                        "    Tag: \"${TAG}\"\n" #
                        "    Current tag/URL points to a commit.\n" #
                        "    Append \"# <branch>\" to the line to configure which branch should be queried for the newest commit.\n" #
                        "    For example, \"# main\"."
        )
    endif ()
endforeach ()

file (WRITE "${PACKAGE_LOCK}" ${CONTENT})
