find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(_dbus_hint QUIET dbus-1)
endif()

find_path(DBUS_INCLUDE_DIR
  NAMES
    dbus/dbus.h
  HINTS
    ${_dbus_hint_INCLUDE_DIRS}
    /opt
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
    ${_dbus_hint_INCLUDE_DIRS}
    /opt/lib
    /usr/local/lib
    /usr/lib
  PATH_SUFFIXES
    dbus-1.0/include
    include/dbus-1.0/
    include/
)

find_library(DBUS_LIB
  NAMES
    dbus-1
  HINTS
    ${_dbus_hint_LIBRARY_DIRS}
    /opt/lib
    /usr/local/lib
    /usr/lib
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
  message(STATUS "Found DBus:
   inc: ${DBUS_INCLUDE_DIRS}
   lib: ${DBUS_LIB}")
  add_library(DBus INTERFACE IMPORTED)
  set_target_properties(DBus PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${DBUS_INCLUDE_DIRS}"
    INTERFACE_LINK_LIBRARIES      "${DBUS_LIB}"
  )
endif()

# vim: ts=2 sw=2 sts=0 expandtab ff=unix :
