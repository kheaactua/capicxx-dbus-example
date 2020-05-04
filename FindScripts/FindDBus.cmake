find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(_dbus_hint QUIET libdbus)
endif()

find_path(DBUS_INCLUDE_DIR
  NAMES
    dbus/dbus.h
  HINTS
    /usr
    $ENV{QNX_HOST}/usr/aarch64-buildroot-nto-qnx/sysroot/usr
    /usr/local
  PATH_SUFFIXES
    include/dbus-1.0/
    include/
    dbus-1.0/
)

find_path(DBUS_ARCH_INCLUDE_DIR
  NAMES
    dbus/dbus-arch-deps.h
  HINTS
    /usr/lib
    $ENV{QNX_HOST}/usr/aarch64-buildroot-nto-qnx/sysroot/aarch64le/usr/lib
    /usr/local/lib

  PATH_SUFFIXES
    dbus-1.0/include
    include/dbus-1.0/
    include/
)

find_library(DBUS_LIB
  NAMES
    dbus-1
  HINTS
    /usr/lib
    $ENV{QNX_HOST}/usr/aarch64-buildroot-nto-qnx/sysroot/aarch64le/usr/lib
    /usr/local/lib
)

# Normalise
get_filename_component(DBUS_INCLUDE_DIR      "${DBUS_INCLUDE_DIR}" ABSOLUTE)
get_filename_component(DBUS_ARCH_INCLUDE_DIR "${DBUS_ARCH_INCLUDE_DIR}" ABSOLUTE)
get_filename_component(DBUS_LIB              "${DBUS_LIB}" ABSOLUTE)

set(DBUS_INCLUDE_DIRS)
list(APPEND DBUS_INCLUDE_DIRS ${DBUS_INCLUDE_DIR})
list(APPEND DBUS_INCLUDE_DIRS ${DBUS_ARCH_INCLUDE_DIR})
list(REMOVE_DUPLICATES DBUS_INCLUDE_DIRS)

mark_as_advanced(DBUS_INCLUDE_DIR DBUS_ARCH_INCLUDE_DIR DBUS_INCLUDE_DIRS DBUS_LIB)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(DBus
  REQUIRED_VARS DBUS_INCLUDE_DIR DBUS_ARCH_INCLUDE_DIR DBUS_LIB
)

if(NOT TARGET DBus)
  message(STATUS "Found DBus: ${DBUS_INCLUDE_DIRS}")
  add_library(DBus INTERFACE IMPORTED)
  set_target_properties(DBus PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${DBUS_INCLUDE_DIRS}"
    INTERFACE_LINK_LIBRARIES      "${DBUS_LIB}"
  )
endif()

# vim: ts=2 sw=2 sts=0 expandtab ff=unix :
