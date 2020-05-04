# CMakeLists for file creating example project.  This build assumes you are
# using the DBus transport layer.

cmake_policy(SET CMP0048 NEW)

project(FNVExamples VERSION 0.2 LANGUAGES CXX)

cmake_minimum_required(VERSION 3.10.2)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(BUILD_TESTS FALSE CACHE BOOL "Option to build unit tests")

# Output location for generated code.  Normally this should go into the build
# directory, but it's convinient for now to place it in the source directory.
set(GEN_OUTPUT_DIR "${CMAKE_SOURCE_DIR}/projects/hello-world/src/capi-src-gen" CACHE PATH "Destination for generated code")

set(CAPI_TRANSPORT "DBus" CACHE STRING "Transport library to use")
set_property(CACHE CAPI_TRANSPORT PROPERTY STRINGS "DBus")
if(NOT CAPI_TRANSPORT STREQUAL "DBus")
  message(FATAL "CAPI_TRANSPORT only supports 'FNV' or 'DBus' (case-sensitive)")
endif()

# Output locations
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Our custom find scripts
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/FindScripts")

set(DBus_GEN "$ENV{WORKSPACE}/src/franca-dev/commonapi_dbus_generator/commonapi-dbus-generator-linux-x86_64" CACHE PATH "commonapi-dbus-generator-linux-x86_64 generator")
set(CAPI_GEN "$ENV{WORKSPACE}/src/franca-dev/commonapi-generator/commonapi-generator-linux-x86_64" CACHE PATH "commonapi-generator-linux-x86_64 generator")

# Code generators
add_executable(gen_capi IMPORTED)
set_property(TARGET gen_capi PROPERTY IMPORTED_LOCATION ${CAPI_GEN})
add_executable(gen_transport IMPORTED)
set_property(TARGET gen_transport PROPERTY IMPORTED_LOCATION ${${CAPI_TRANSPORT}_GEN})

include(GenerateCapiCode.cmake)

add_subdirectory("projects")

# vim: ts=2 sw=2 sts=0 expandtab ff=unix :
