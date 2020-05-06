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

Add the following to your environment to properly use the patched DBus:
```sh
export PKG_CONFIG_PATH=/opt/lib/pkgconfig
export LD_LIBRARY_PATH=/opt/lib
```

Run the following install script to install
- [capicxx-core-runtime](https://github.com/GENIVI/capicxx-core-runtime.git)
- a patched DBus: installed to `/opt`
- [capicxx-dbus-runtime](https://github.com/GENIVI/capicxx-dbus-runtime.git)

Then, with mavin install:
- [capicxx-core-tools](https://github.com/GENIVI/capicxx-core-tools) and
- [capicxx-dbus-tools](https://github.com/GENIVI/capicxx-dbus-tools) with maven.
The commands below assume that you clone these repos into `${HOME}/workspace`

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
  -DDBus_GEN=${HOME}/workspace/capicxx-dbus-tools/org.genivi.commonapi.dbus.cli.product/target/products/org.genivi.commonapi.dbus.cli.product/linux/gtk/x86_64/commonapi-dbus-generator-linux-x86_64
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
it means that your system DBus is conflicting with the patched DBus.  Ensure you're using the patched dbus (check this with the `ldd` command), and ensure DBus is running:

```sh
sudo dbus-daemon --system
```

## Notes:
- I suspect I should change the DBus version to match the system version, or
  that I'm not installing it properly, or shouldn't force it as much as I am to
  use the patched version.

[modeline]: # ( vim: set fenc=utf-8 spell spl=en ts=2 sw=2 expandtab sts=0 ff=unix : )
