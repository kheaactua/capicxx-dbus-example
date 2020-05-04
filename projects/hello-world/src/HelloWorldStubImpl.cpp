#include "HelloWorldStubImpl.hpp"

auto HelloWorldStubImpl::sayHello(
    std::shared_ptr<CommonAPI::ClientId> const _client,
    std::string _name,
    sayHelloReply_t _reply) -> void
{
    std::stringstream messageStream;
    messageStream << "Hello " << _name << "!";
    std::cout << "sayHello('" << _name << "'): '" << messageStream.str() << "'\n";

    _reply(messageStream.str());
}
