#!/bin/bash

declare install_dir=/usr/local
declare source_dir=${install_dir}/src
declare dbus_install_dir=/opt/

if [[ $EUID -eq 0 ]]; then
  apt install -qy libgtest-dev doxygen pkg-config libcairo2-dev libexpat1
fi

echo "Installing CommonAPI"
capi_dir="${source_dir}/capicxx-core-runtime"
if [[ ! -e "${capi_dir}" ]]; then
  git clone https://github.com/GENIVI/capicxx-core-runtime.git "${capi_dir}"
fi
cd "${capi_dir}"
git fetch origin
git reset --hard origin/master
if [[ ! -e build ]]; then
  mkdir build
fi
cd build
cmake -D CMAKE_INSTALL_PREFIX="${install_dir}" .. \
  && make                                         \
  && make install

declare capicxx_dbus_runtime_dir="${source_dir}/capicxx-dbus-runtime"
VERSION_DBUS=1.12.16
echo -e "\nPatching libdbus"
if [[ ! -e "${capicxx_dbus_runtime_dir}" ]]; then
  git clone https://github.com/GENIVI/capicxx-dbus-runtime.git "${capicxx_dbus_runtime_dir}"
fi
cd "${capicxx_dbus_runtime_dir}"
git fetch
git reset --hard origin/master
patch_files=$(echo ${capicxx_dbus_runtime_dir}/src/dbus-patches/*.patch)

if [[ ! -e "${capicxx_dbus_runtime_dir}/dbus-${VERSION_DBUS}.tar.gz" ]]; then
  wget -O "${capicxx_dbus_runtime_dir}/dbus-${VERSION_DBUS}.tar.gz" \
  "http://dbus.freedesktop.org/releases/dbus/dbus-${VERSION_DBUS}.tar.gz"
fi
tar -xzf "${capicxx_dbus_runtime_dir}/dbus-${VERSION_DBUS}.tar.gz" -C "${capicxx_dbus_runtime_dir}" \
  && cd "${capicxx_dbus_runtime_dir}/dbus-${VERSION_DBUS}"                          \
  && for f in ${patch_files}; do
    echo "Applying ${f}";
    patch -N -i "${f}" -p1;
  done                                          \
  && ./configure --prefix="${dbus_install_dir}" \
  && make -C dbus                               \
  && make -C dbus install                       \
  && make install-pkgconfigDATA

echo "Building common-api-dbus-runtime"
export PKG_CONFIG_PATH="${dbus_install_dir}/lib/pkgconfig:${PKG_CONFIG_PATH}"
cd "${capicxx_dbus_runtime_dir}"
if [[ ! -e build ]]; then
  mkdir build
fi
cd build
cmake "${capicxx_dbus_runtime_dir}"     \
  -DUSE_INSTALLED_COMMONAPI=ON          \
  -DUSE_INSTALLED_DBUS=OFF              \
  -DCMAKE_INSTALL_PREFIX=${install_dir} \
  && make                               \
  && make install

# vim: ts=2 sw=2 sts=0 expandtab ff=unix :
