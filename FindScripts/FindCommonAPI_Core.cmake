FIND_PACKAGE(PkgConfig)
FIND_PACKAGE(Threads REQUIRED)

find_path(CommonAPI_Core_CMAKE_DIR
  NAMES CommonAPIConfig.cmake
  PATHS
    /usr/lib/cmake/CommonAPI-${CommonAPI_Core_FIND_VERSION}
    $ENV{QNX_HOST}/usr/aarch64-buildroot-nto-qnx/sysroot/usr/lib/cmake/CommonAPI-${CommonAPI_Core_FIND_VERSION}
    /usr/local/lib/cmake/CommonAPI-${CommonAPI_Core_FIND_VERSION}
)
if(CommonAPI_Core_CMAKE_DIR)
  find_package(CommonAPI ${CommonAPI_Core_FIND_VERSION} REQUIRED
    PATHS ${CommonAPI_Core_CMAKE_DIR}
  )
endif()

# Normalise COMMONAPI_INCLUDE_DIRS
get_filename_component(COMMONAPI_INCLUDE_DIRS "${COMMONAPI_INCLUDE_DIRS}" ABSOLUTE)

mark_as_advanced(CommonAPI_Core_CMAKE_DIR COMMONAPI_INCLUDE_DIRS COMMONAPI_VERSION)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CommonAPI_Core
  REQUIRED_VARS COMMONAPI_INCLUDE_DIRS CommonAPI_Core_CMAKE_DIR
  VERSION_VAR COMMONAPI_VERSION
)

if(NOT TARGET CommonAPI::Core)
  add_library(CommonAPI::Core INTERFACE IMPORTED)
  set_target_properties(CommonAPI::Core PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${COMMONAPI_INCLUDE_DIRS}"
    INTERFACE_LINK_LIBRARIES      "CommonAPI"
  )
endif()

# vim: ts=2 sw=2 sts=0 expandtab ff=unix :
