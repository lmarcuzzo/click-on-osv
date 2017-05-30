#!/bin/bash
echo "Init Submodules"
git submodule update --init --recursive
echo "Building DPDK"
cd dpdk
git checkout osv-head
cd ..
#adapted from https://github.com/syuu1228/dpdk/blob/osv-head/lib/librte_eal/osvapp/capstan/GET
export RTE_SDK=`readlink -f dpdk`
export RTE_TARGET=x86_64-native-osvapp-gcc
export OSV_SDK=`readlink -f osv`
cd $RTE_SDK
make install T=$RTE_TARGET OSV_SDK=$OSV_SDK
cd ..
mkdir -p binary
cp -fa $RTE_SDK/x86_64-native-osvapp-gcc/lib/libintel_dpdk.so binary/
#build click
echo "Building Click"
#git clone https://github.com/lmarcuzzo/click
cd click
make clean
./configure --enable-dpdk --enable-osv --enable-user-multithread --disable-linuxmodule CXXFLAGS="-fPIC -std=gnu++11" CFLAGS="-fPIC" LDFLAGS="-fPIC -std=gnu++11" CPPFLAGS="-fPIC -std=gnu++11"
cd userlevel
make
cp click ../../binary
cd ../../
echo "Building OSv"
cp binary/* osv/modules/click
cd osv
./scripts/setup.py
git submodule update --init --recursive
./scripts/build modules=click,httpserver-click_plugin
./scripts/gen-vbox-ova.sh
cp build/last/usr.img ../images/click-on-osv.img
cp build/last/osv.ova ../images/click-on-osv.ova
