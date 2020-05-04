find_package(DBus)

find_path(CommonAPI_DBus_CMAKE_DIR
  NAMES CommonAPI-DBusConfig.cmake
  PATHS
    /usr/lib/cmake/CommonAPI-DBus-${CommonAPI_DBus_FIND_VERSION}
    $ENV{QNX_HOST}/usr/aarch64-buildroot-nto-qnx/sysroot/usr/lib/cmake/CommonAPI-DBus-${CommonAPI_DBus_FIND_VERSION}
    /usr/local/lib/cmake/CommonAPI-DBus-${CommonAPI_DBus_FIND_VERSION}
)
if(CommonAPI_DBus_CMAKE_DIR)
  find_package(CommonAPI-DBus ${CommonAPI_DBus_FIND_VERSION} REQUIRED
    PATHS ${CommonAPI_DBus_CMAKE_DIR}
  )
endif()

find_library(CommonAPI_DBus_LIBRARY
  NAMES CommonAPI-DBus
  PATHS
    /usr/lib
    $ENV{QNX_HOST}/usr/aarch64-buildroot-nto-qnx/sysroot/usr/lib
    /usr/local/lib
)

# Normalise COMMONAPI_DBUS_INCLUDE_DIRS
get_filename_component(COMMONAPI_DBUS_INCLUDE_DIRS "${COMMONAPI_DBUS_INCLUDE_DIRS}" ABSOLUTE)
get_filename_component(CommonAPI_DBus_LIBRARY     "${CommonAPI_DBus_LIBRARY}" ABSOLUTE)

mark_as_advanced(CommonAPI_DBUS_CMAKE_DIR COMMONAPI_DBUS_INCLUDE_DIRS COMMONAPI_DBUS_VERSION CommonAPI_DBus_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CommonAPI_DBus
  REQUIRED_VARS COMMONAPI_DBUS_INCLUDE_DIRS CommonAPI_DBus_LIBRARY
  VERSION_VAR COMMONAPI_DBUS_VERSION
)

if(NOT TARGET CommonAPI::DBus)
  add_library(CommonAPI::DBus INTERFACE IMPORTED)
  set_target_properties(CommonAPI::DBus PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${COMMONAPI_DBUS_INCLUDE_DIRS}"
    INTERFACE_LINK_LIBRARIES      "${CommonAPI_DBus_LIBRARY}"
  )

  # Copy DBus properties, we do this because imported targets can't depend on
  # other targets, but we don't want to always have to also include dbus
  foreach(var IN ITEMS INTERFACE_INCLUDE_DIRECTORIES INTERFACE_LINK_LIBRARIES)
    get_target_property(tmp DBus ${var})
    set_property(TARGET CommonAPI::DBus APPEND PROPERTY ${var} "${tmp}")
  endforeach()
  unset(TMP)
endif()

# vim: ts=2 sw=2 sts=0 expandtab ff=unix :
