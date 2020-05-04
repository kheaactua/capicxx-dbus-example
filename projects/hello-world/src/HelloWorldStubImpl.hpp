#ifndef HWSTUBIMPL_HPP_PN3SIJWB
#define HWSTUBIMPL_HPP_PN3SIJWB

#include <chrono>
#include <memory>

#include <CommonAPI/CommonAPI.hpp>

#include "v1/commonapi/HelloWorldStubDefault.hpp"

class HelloWorldStubImpl : public v1_0::commonapi::HelloWorldStubDefault
{
  public:
    HelloWorldStubImpl() = default;
    virtual ~HelloWorldStubImpl() = default;

    virtual auto sayHello(
        const std::shared_ptr<CommonAPI::ClientId> _client,
        std::string _name,
        sayHelloReply_t _return) -> void;
};

#endif /* end of include guard: HWSTUBIMPL_HPP_PN3SIJWB */
