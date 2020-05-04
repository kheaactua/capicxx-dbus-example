# Run code generators for a specific fidl file and transport library
# This code will create the following variables in the form:
#  {PREFIX}_{CORE/TRANSPORT}_{PROXY/STUB/COMMON/SKELETON}_DIR
# And create custom targets to generate the code into OUTPUT_DIR
#
# Example usage:
#
# SET_UP_GEN_FILES(
#   FILD_FILE  ${CMAKE_SOURCE_DIR}/fidl/HelloWorld.fidl
#   OUTPUT_DIR ${GEN_OUTPUT_DIR}
#   VAR_PREFIX "HW"
#   VERSION 1
#   INTERFACES HelloWorld
# )
macro(SET_UP_GEN_FILES)
  set(options)
  set(oneValueArgs OUTPUT_DIR FILD_FILE VAR_PREFIX VERSION)
  set(multiValueArgs INTERFACES)
  cmake_parse_arguments(
    SUGF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN}
  )

  # set(core directory hierarchy)
  set("${SUGF_VAR_PREFIX}_CORE_BASE_DIR"     "${SUGF_OUTPUT_DIR}/core")
  set("${SUGF_VAR_PREFIX}_CORE_COMMON_DIR"   "${${SUGF_VAR_PREFIX}_CORE_BASE_DIR}/common")
  set("${SUGF_VAR_PREFIX}_CORE_PROXY_DIR"    "${${SUGF_VAR_PREFIX}_CORE_BASE_DIR}/proxy")
  set("${SUGF_VAR_PREFIX}_CORE_STUB_DIR"     "${${SUGF_VAR_PREFIX}_CORE_BASE_DIR}/stub")
  set("${SUGF_VAR_PREFIX}_CORE_SKELETON_DIR" "${${SUGF_VAR_PREFIX}_CORE_BASE_DIR}/skeleton")

  # set(DBus directory hierarchy)
  if(${CAPI_TRANSPORT} STREQUAL "DBus")
    set("${SUGF_VAR_PREFIX}_TRANSPORT_BASE_DIR"     "${SUGF_OUTPUT_DIR}/dbus")
  else()
    set("${SUGF_VAR_PREFIX}_TRANSPORT_BASE_DIR"     "${SUGF_OUTPUT_DIR}/soa")
  endif()
  set("${SUGF_VAR_PREFIX}_TRANSPORT_COMMON_DIR"   "${${SUGF_VAR_PREFIX}_TRANSPORT_BASE_DIR}/common")
  set("${SUGF_VAR_PREFIX}_TRANSPORT_PROXY_DIR"    "${${SUGF_VAR_PREFIX}_TRANSPORT_BASE_DIR}/proxy")
  set("${SUGF_VAR_PREFIX}_TRANSPORT_STUB_DIR"     "${${SUGF_VAR_PREFIX}_TRANSPORT_BASE_DIR}/stub")

  set("${SUGF_VAR_PREFIX}_CAPI_GEN_CORE_FILES")
  set("${SUGF_VAR_PREFIX}_CAPI_GEN_${CAPI_TRANSPORT}_FILES")
  foreach(name IN LISTS SUGF_INTERFACES)
    # Core
    list(APPEND "${SUGF_VAR_PREFIX}_CAPI_GEN_CORE_FILES" ${${SUGF_VAR_PREFIX}_CORE_COMMON_DIR}/v${SUGF_VERSION}/commonapi/${name}.hpp)
    list(APPEND "${SUGF_VAR_PREFIX}_CAPI_GEN_CORE_FILES" ${${SUGF_VAR_PREFIX}_CORE_PROXY_DIR}/v${SUGF_VERSION}/commonapi/${name}Proxy.hpp)
    list(APPEND "${SUGF_VAR_PREFIX}_CAPI_GEN_CORE_FILES" ${${SUGF_VAR_PREFIX}_CORE_PROXY_DIR}/v${SUGF_VERSION}/commonapi/${name}ProxyBase.hpp)
    list(APPEND "${SUGF_VAR_PREFIX}_CAPI_GEN_CORE_FILES" ${${SUGF_VAR_PREFIX}_CORE_SKELETON_DIR}/v${SUGF_VERSION}/commonapi/${name}StubDefault.cpp)
    list(APPEND "${SUGF_VAR_PREFIX}_CAPI_GEN_CORE_FILES" ${${SUGF_VAR_PREFIX}_CORE_SKELETON_DIR}/v${SUGF_VERSION}/commonapi/${name}StubDefault.hpp)
    list(APPEND "${SUGF_VAR_PREFIX}_CAPI_GEN_CORE_FILES" ${${SUGF_VAR_PREFIX}_CORE_STUB_DIR}/v${SUGF_VERSION}/commonapi/${name}Stub.hpp)

    # Transport
    list(APPEND "${SUGF_VAR_PREFIX}_CAPI_GEN_TRANSPORT_FILES" ${${SUGF_VAR_PREFIX}_TRANSPORT_COMMON_DIR}/v${SUGF_VERSION}/commonapi/${name}${CAPI_TRANSPORT}Deployment.hpp)
    list(APPEND "${SUGF_VAR_PREFIX}_CAPI_GEN_TRANSPORT_FILES" ${${SUGF_VAR_PREFIX}_TRANSPORT_COMMON_DIR}/v${SUGF_VERSION}/commonapi/${name}${CAPI_TRANSPORT}Deployment.cpp)
    list(APPEND "${SUGF_VAR_PREFIX}_CAPI_GEN_TRANSPORT_FILES" ${${SUGF_VAR_PREFIX}_TRANSPORT_PROXY_DIR}/v${SUGF_VERSION}/commonapi/${name}${CAPI_TRANSPORT}Proxy.hpp)
    list(APPEND "${SUGF_VAR_PREFIX}_CAPI_GEN_TRANSPORT_FILES" ${${SUGF_VAR_PREFIX}_TRANSPORT_PROXY_DIR}/v${SUGF_VERSION}/commonapi/${name}${CAPI_TRANSPORT}Proxy.cpp)
    list(APPEND "${SUGF_VAR_PREFIX}_CAPI_GEN_TRANSPORT_FILES" ${${SUGF_VAR_PREFIX}_TRANSPORT_STUB_DIR}/v${SUGF_VERSION}/commonapi/${name}${CAPI_TRANSPORT}StubAdapter.hpp)
    list(APPEND "${SUGF_VAR_PREFIX}_CAPI_GEN_TRANSPORT_FILES" ${${SUGF_VAR_PREFIX}_TRANSPORT_STUB_DIR}/v${SUGF_VERSION}/commonapi/${name}${CAPI_TRANSPORT}StubAdapter.cpp)
  endforeach()

  message(STATUS "Create target for ${SUGF_INTERFACES} transport files:")
  foreach(f IN LISTS ${SUGF_VAR_PREFIX}_CAPI_GEN_TRANSPORT_FILES)
    message(" - ${f}")
  endforeach()
  add_custom_command(
    COMMAND gen_transport
      --dest-common="${${SUGF_VAR_PREFIX}_TRANSPORT_COMMON_DIR}"
      --dest-proxy="${${SUGF_VAR_PREFIX}_TRANSPORT_PROXY_DIR}"
      --dest-stub="${${SUGF_VAR_PREFIX}_TRANSPORT_STUB_DIR}"
      "${SUGF_FILD_FILE}"
    DEPENDS ${SUGF_FILD_FILE}
    OUTPUT  ${${SUGF_VAR_PREFIX}_CAPI_GEN_TRANSPORT_FILES}
    COMMENT "Generating CAPI ${CAPI_TRANSPORT} binding code for ${SUGF_FILD_FILE}"
  )

  message(STATUS "Create target for ${SUGF_INTERFACES} core files:")
  foreach(f IN LISTS ${SUGF_VAR_PREFIX}_CAPI_GEN_CORE_FILES)
    message(" - ${f}")
  endforeach()
  add_custom_command(
    COMMAND gen_capi
      --dest-common="${${SUGF_VAR_PREFIX}_CORE_COMMON_DIR}"
      --dest-proxy="${${SUGF_VAR_PREFIX}_CORE_PROXY_DIR}"
      --dest-stub="${${SUGF_VAR_PREFIX}_CORE_STUB_DIR}"
      --dest-skel="${${SUGF_VAR_PREFIX}_CORE_SKELETON_DIR}"
      -sk
      "${SUGF_FILD_FILE}"
    DEPENDS ${SUGF_FILD_FILE}
    OUTPUT  ${${SUGF_VAR_PREFIX}_CAPI_GEN_CORE_FILES}
    COMMENT "Generating CAPI core code for ${SUGF_FILD_FILE}"
  )
endmacro()

# vim: ts=2 sw=2 sts=0 expandtab ff=unix :
