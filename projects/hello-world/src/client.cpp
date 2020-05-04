#include <atomic>
#include <chrono>
#include <iostream>
#include <string>
#include <thread>

#include <CommonAPI/CommonAPI.hpp>

#include "v1/commonapi/HelloWorldProxy.hpp"

#define STR_EXPAND(x) #x
#define STR(y) STR_EXPAND(y)


auto main() -> int
{
    auto const polling_interval = std::chrono::milliseconds{200};

    std::cout << "Starting " << STR(CAPI_TRANSPORT) << " HelloWorld Client\n";

    auto runtime = CommonAPI::Runtime::get();

    auto proxy = runtime->buildProxy<v1_0::commonapi::HelloWorldProxy>("local", "Hello_World");
    if (!proxy)
    {
        std::cerr << "Could not build proxy\n";
        exit(0);
    }

    // Listen for when the service event changes.
    auto const subscription_status = proxy->getProxyStatusEvent().subscribe(
        [&](const CommonAPI::AvailabilityStatus &availabilityStatus) {
            std::cout
                << "$$ proxy AvailabilityStatus: "
                << (CommonAPI::AvailabilityStatus::AVAILABLE == availabilityStatus ? " " : "NOT ")
                << "AVAILABLE\n";
        }
    );

    // Wait for the proxy to be available
    while (!proxy->isAvailable())
        std::this_thread::sleep_for(std::chrono::microseconds{10});
    std::cout << "$ Proxy available..." << std::endl;

    bool continue_run = true;
    auto subscription_shutdown = proxy->getShutdownEvent().subscribe([&continue_run]()
    {
        std::cout << "Received shutdown signal from service\n";
        continue_run = false;
    });

    while (continue_run)
    {
        std::this_thread::sleep_for(polling_interval);
    }

    std::cout << "Shutting down\n";
    proxy->getShutdownEvent().unsubscribe(subscription_shutdown);
    proxy->getProxyStatusEvent().unsubscribe(subscription_status);

    return 0;
}
