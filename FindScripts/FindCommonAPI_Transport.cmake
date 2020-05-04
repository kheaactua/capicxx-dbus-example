# Really a wrapper to load the proper transport library

if(NOT TARGET CAPI_TRANSPORT_LIB)
  if(${CAPI_TRANSPORT} STREQUAL "DBus")
    find_package(CommonAPI_DBus 3.1.12 REQUIRED)
  else()
    find_package(CommonAPI_FNV 3.1.0 REQUIRED)
  endif()

  # Create an interface for our chosen transport lib (dbus or CommonAPI-FNV)
  add_library(CAPI_TRANSPORT_LIB INTERFACE)
  message(STATUS "Configuring build for ${CAPI_TRANSPORT} transport library")
  if(${CAPI_TRANSPORT} STREQUAL "DBus")
    target_link_libraries(CAPI_TRANSPORT_LIB INTERFACE CommonAPI::DBus)
  else()
    target_link_libraries(CAPI_TRANSPORT_LIB INTERFACE CommonAPI::FNV)
  endif()
endif()

# vim: ts=2 sw=2 sts=0 expandtab ff=unix :
