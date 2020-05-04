#ifndef HWSTUBIMPL_HPP_PN3SIJWB
#define HWSTUBIMPL_HPP_PN3SIJWB

#include <chrono>
#include <memory>

#include <CommonAPI/CommonAPI.hpp>

#include "v1/commonapi/HelloWorldStubDefault.hpp"

class HelloWorldStubImpl : public v1_0::commonapi::HelloWorldStubDefault
{
    using CLOCK = std::chrono::system_clock;

  public:
    HelloWorldStubImpl() = default;
    virtual ~HelloWorldStubImpl() = default;
};

#endif /* end of include guard: HWSTUBIMPL_HPP_PN3SIJWB */
