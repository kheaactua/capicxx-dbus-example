project(HelloWorld VERSION 0.1 LANGUAGES CXX)

find_package(CommonAPI_Core 3.1.12 REQUIRED)
find_package(CommonAPI_Transport REQUIRED)

SET_UP_GEN_FILES(
  FILD_FILE ${PROJECT_SOURCE_DIR}/fidl/HelloWorld.fidl
  OUTPUT_DIR ${GEN_OUTPUT_DIR}
  VAR_PREFIX "HW"
  VERSION 1
  INTERFACES HelloWorld
)

# Include directories for generated code
set(CAPI_INCLUDE_DIRS
  ${HW_CORE_COMMON_DIR}      ${HW_CORE_PROXY_DIR}      ${HW_CORE_STUB_DIR}      ${HW_CORE_SKELETON_DIR}
  ${HW_TRANSPORT_COMMON_DIR} ${HW_TRANSPORT_PROXY_DIR} ${HW_TRANSPORT_STUB_DIR}
)
list(REMOVE_DUPLICATES CAPI_INCLUDE_DIRS)
message(STATUS "${PROJECT_NAME} capi generated include directories:")
foreach(inc IN LISTS CAPI_INCLUDE_DIRS)
  message(" ${inc}")
endforeach()

add_executable(hw_client
    src/client.cpp
    ${HW_TRANSPORT_PROXY_DIR}/v1/commonapi/HelloWorld${CAPI_TRANSPORT}Proxy.cpp
)
set_target_properties(hw_client PROPERTIES OUTPUT_NAME "HelloWorld-${CAPI_TRANSPORT}-client")
target_link_libraries(hw_client
  PUBLIC
    CommonAPI::Core
    CAPI_TRANSPORT_LIB
)
target_include_directories(hw_client
  PUBLIC
    ${CAPI_INCLUDE_DIRS}
)
target_compile_definitions(hw_client PUBLIC -DCAPI_TRANSPORT=${CAPI_TRANSPORT})


add_executable(hw_service
  src/service.cpp
  src/HelloWorldStubImpl.cpp

  ${HW_TRANSPORT_STUB_DIR}/v1/commonapi/HelloWorld${CAPI_TRANSPORT}StubAdapter.cpp
  ${HW_CORE_SKELETON_DIR}/v1/commonapi/HelloWorldStubDefault.cpp
  ${HW_CORE_PROXY_DIR}/v1/commonapi/HelloWorldProxy.hpp
)
set_target_properties(hw_service PROPERTIES OUTPUT_NAME "HelloWorld-${CAPI_TRANSPORT}-service")
target_link_libraries(hw_service
  PUBLIC
    CommonAPI::Core
    CAPI_TRANSPORT_LIB
)
target_include_directories(hw_service
  PUBLIC
    ${CAPI_INCLUDE_DIRS}
)
target_compile_definitions(hw_service PUBLIC -DCAPI_TRANSPORT=${CAPI_TRANSPORT})

# C++ Standard
set_target_properties(hw_service hw_client PROPERTIES CXX_STANDARD 14)

# vim: ts=2 sw=2 sts=0 expandtab ff=unix :
