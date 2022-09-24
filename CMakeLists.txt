cmake_policy(SET CMP0048 NEW)
cmake_minimum_required(VERSION 3.9)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

project(sparkler VERSION 0.0.1 LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED)

if(EXISTS "${CMAKE_SOURCE_DIR}/.git")
    execute_process(
        COMMAND git rev-parse --abbrev-ref HEAD
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_BRANCH
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
        COMMAND git log -1 --format=%h
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COMMIT_HASH
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
else()
    set(GIT_BRANCH "not_a_git_checkout")
    set(GIT_COMMIT_HASH "na")
endif()

message(STATUS "sparkler v${PROJECT_VERSION}, ${GIT_BRANCH}@${GIT_COMMIT_HASH}")

# required if linking to static library
add_definitions(-DANTLR4CPP_STATIC)

# using /MD flag for antlr4_runtime (for Visual C++ compilers only)
set(ANTLR4_WITH_STATIC_CRT OFF)

# Specify the version of the antlr4 library needed for this project.
# By default the latest version of antlr4 will be used. You can specify a
# specific, stable version by setting a repository tag value or a link
# to a zip file containing the libary source.
set(ANTLR4_TAG 4.11.1)
# set(ANTLR4_ZIP_REPOSITORY https://github.com/antlr/antlr4/archive/refs/tags/4.11.1.zip)

# set variable pointing to the antlr tool that supports C++
# this is not required if the jar file can be found under PATH environment
# set(ANTLR_EXECUTABLE /home/user/antlr-4.11.1-complete.jar)

# add external build for antlrcpp
include(ExternalAntlr4Cpp)

# Add the grammar ANTLR targets
add_subdirectory(grammar)
add_subdirectory(demo)
