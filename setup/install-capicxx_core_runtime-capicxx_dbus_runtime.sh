#!/bin/bash

declare install_dir=/usr/local
declare source_dir=${install_dir}/src

apt install -qy libgtest-dev doxygen pkg-config libcairo2-dev libexpat1

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

declare dbus_dir="${source_dir}/capicxx-dbus-runtime"
VERSION=1.12.16
echo "Patching libdbus"
git clone https://github.com/GENIVI/capicxx-dbus-runtime.git "${dbus_dir}"
patch_files=$(echo ${dbus_dir}/src/dbus-patches/*.patch)
tmp="$(mktemp -d)"

# apt remove -qy dbus
wget -O "${tmp}/dbus-${VERSION}.tar.gz"                              \
  "http://dbus.freedesktop.org/releases/dbus/dbus-${VERSION}.tar.gz" \
  && tar -xzf "${tmp}/dbus-${VERSION}.tar.gz" -C "${source_dir}"     \
  && cd "${source_dir}/dbus-${VERSION}"                              \
  && for f in ${patch_files}; do
    echo "Applying ${f}";
    patch -N -i "${f}" -p1;
  done                                                               \
  && ./configure --prefix="${install_dir}"                           \
  && make -C dbus                                                    \
  && make -C dbus install                                            \
  && make install-pkgconfigDATA

echo "Building common-api-dbus-runtime"
export PKG_CONFIG_PATH="${install_dir}/lib/pkgconfig:$PKG_CONFIG_PATH"
cd "${dbus_dir}"
if [[ ! -e build ]]; then
  mkdir build
fi
cd build
cmake -D USE_INSTALLED_COMMONAPI=ON -DCMAKE_INSTALL_PREFIX=${install_dir} "${dbus_dir}" \
  && make                                                                               \
  && make install

# vim: ts=2 sw=2 sts=0 expandtab ff=unix :
