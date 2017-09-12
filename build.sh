#!/bin/bash
#Set variables for build
function set_vars_and_deps {
  echo "Setting Environment Vars"
  export RTE_SDK=`readlink -f osv-dpdk`
  export RTE_TARGET=x86_64-native-osvapp-gcc
  export OSV_SDK=`readlink -f osv`
  if [ -z "$RTE_SDK" ] || [ -z "$RTE_TARGET" ] || [ -z "$OSV_SDK" ]; then
    echo "Error setting variables"
    exit 1
  fi
  echo "Download dependencies"
  $OSV_SDK/scripts/setup.py
  mkdir -p $COOV_FOLDER/binary
}

#adapted from https://github.com/syuu1228/osv-dpdk/blob/osv-head/lib/librte_eal/osvapp/capstan/GET
function build_dpdk {
  echo "Building DPDK"
  cd osv-dpdk
  git checkout osv-head
  make install T=$RTE_TARGET OSV_SDK=$OSV_SDK
  if [ ! -e "$RTE_SDK/x86_64-native-osvapp-gcc/lib/libintel_dpdk.so" ]; then
    echo "Error building DPDK"
    exit 1
  else
     cp -fa $RTE_SDK/x86_64-native-osvapp-gcc/lib/libintel_dpdk.so $COOV_FOLDER/binary
   fi
   cd $COOV_FOLDER
}

function build_click {
  echo "Building Click"
  cd click
  ./configure --enable-dpdk --enable-osv --enable-user-multithread --enable-local --enable-wifi --disable-linuxmodule CXXFLAGS="-fPIC -std=gnu++11" CFLAGS="-fPIC" LDFLAGS="-fPIC -std=gnu++11" CPPFLAGS="-fPIC -std=gnu++11"
  make elemlist
  cd userlevel
  make
  if [ ! -e "click" ]; then
    echo "Error Building Click"
    exit 1
  else
    cp -fa click $COOV_FOLDER/binary
  fi
  cd $COOV_FOLDER
}

function build_osv {
  cp binary/* $OSV_SDK/modules/click
  cd $OSV_SDK
  ./scripts/build modules=click,httpserver-click_plugin
  #./scripts/gen-vbox-ova.sh
  if [ ! -e "$OSV_SDK/build/last/usr.img" ]; then
    echo "Error building OSv"
    exit 1
  else
    cp $OSV_SDK/build/last/usr.img $COOV_FOLDER/images/click-on-osv.img
    #cp $OSV_SDK/build/last/osv.ova $COOV_FOLDER/images/click-on-osv.ova
  fi
}

#Define root folder
COOV_FOLDER=`pwd`
#Init submodules
git submodule update --init --recursive
#Set variables
set_vars_and_deps
#Build DPDK
build_dpdk
#Build click
build_click
#Build OSv
build_osv
