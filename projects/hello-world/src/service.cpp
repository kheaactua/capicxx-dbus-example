#include <chrono>
#include <fstream>
#include <future>
#include <iostream>
#include <thread>

#include <CommonAPI/CommonAPI.hpp>

#include "v1/commonapi/HelloWorldStubDefault.hpp"
// #include "HelloWorldStubImpl.hpp"

#define STR_EXPAND(x) #x
#define STR(y) STR_EXPAND(y)

auto main(int const argc, char *argv[]) -> int
{
    std::cout << "Starting " << STR(CAPI_TRANSPORT) << " Hello World Service\n";

    auto runtime = CommonAPI::Runtime::get();
    auto service = std::make_shared<v1_0::commonapi::HelloWorldStubDefault>();
    if (runtime->registerService("local", "Hello_World", service))
    {
        std::cout << "Hello_World service has been registered" << std::endl;
    }
    else
    {
        std::cout << "Hello_World registration fail" << std::endl;
    }

    while (true)
    {
        std::string cin_str;
        std::cin >> cin_str;
        if (cin_str == "Q")
        {
            break;
        }
    }

    std::cout << "Sending shutdown signal to clients" << "\n";
    service->fireShutdownEvent();

    runtime->unregisterService("local", "Hello_World", "");

    service.reset();

    return 0;
}
