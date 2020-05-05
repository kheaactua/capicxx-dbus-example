# Overview

Simply CommonAPI example with DBus.  Written as a starter project to help new people start with a working Hello World example.  Next step from here would be the actual [capicxx-core-tools Hello World](https://github.com/GENIVI/capicxx-core-tools/tree/master/CommonAPI-Examples/E01HelloWorld) example, then perhaps the phone book example.

# Build

## Pre-Requisites

Before starting, please install Java 8
```sh
sudo apt install openjdk-8-jre-headless openjdk-8-jdk -qy \
  && sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java \
  && sudo update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac
```

Run this on a system that already has (see `setup/install-capicxx_core_runtime-capicxx_dbus_runtime.sh`)
- capicxx-core-tools
- patched dbus

Then, install [capicxx-core-tools](https://github.com/GENIVI/capicxx-core-tools) with maven.

# Build

The `DBus_GEN` and `CAPI_GEN` `CMake` definitions must be updated to point to
your generators.  This can be done in the code or in your environment.

```sh
git clone//github.com/kheaactua/capicxx-dbus-example.git 
cd capicxx-dbus-example.git
mkdir bld
cd bld
cmake ..                             \
  -DCMAKE_BUILD_TYPE=Debug           \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=On \
  -DCAPI_GEN=${HOME}/workspace/capicxx-core-tools/org.genivi.commonapi.core.cli.product/target/products/org.genivi.commonapi.core.cli.product/linux/gtk/x86_64/commonapi-generator-linux-x86_64 \
cmake --build .
```

Preferable in separate terminals, run:
```sh
bin/HelloWorld-DBus-service
```

```sh
bin/HelloWorld-DBus-client
```

Enter text into the client to invoke the `sayHello`, uppercase `Q` will cause
the executable to quit.

# Troubleshooting

If you receive DBus errors such as
```
dbus-daemon: /usr/local/lib/libdbus-1.so.3: version `LIBDBUS_PRIVATE_1.12.2' not found (required by dbus-daemon)
```
it means that your DBus isn't installed properly.  This is likely a result of
the install script above installing DBus over a previously installed version.
While it now attempts to first uninstall DBus, if that didn't work, uninstall
DBus with apt, run the DBus installer from the script above, and launch the
service:

```sh
sudo dbus-daemon --system
```

[modeline]: # ( vim: set fenc=utf-8 spell spl=en ts=2 sw=2 expandtab sts=0 ff=unix : )
