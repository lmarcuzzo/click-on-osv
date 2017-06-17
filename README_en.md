# Click on OSv

This project aims to execute the [Click Modular Router](https://github.com/kohler/click) on [OSv](https://github.com/cloudius-systems/osv) Unikernell. The Click module is compiled as an user level application with [Intel DPDK](https://github.com/syuu1228/dpdk) modified version support running on OSv.

## Limitations
Compilation has been tested on Debian 8. On environments with Glib > 2.19 an error while linking Click and the DPDK library can occur. This can be tested with ```ldd -d click``` on the Click binary. It should show a libintel_dpdk.so library on the dependencies. GCC has to be at least version 4.8. GCC 5.x and 6.x seems to have some issues compiling DPDK.

## Use

A precompiled version is avaible for download as a "qcow2" disk or an "ova" appliance for VirtualBox. These images and how to install and use them are located in [images](./images).

## Compiling

"build.sh" script is used to compile DPDK, Click and OSv and provides in **binary** folder the DPDK library (*libintel_dpdk.so*) and Click binary (*click*), as well images in (*images*). Example VNFs can be found in [click_confs](click_confs) folder.


Before compiling, download the submodules. From the root folder, run:
You should also install any dependence needed by osv before compiling. This can be done
running scritps/setup.py inside the osv folder.

```
git submodule update --init --recursive
```

### DPDK

For DPDK's compiling process:

Environment variables definition at root folder ->
```
#DPDK's Folder
export RTE_SDK=`readlink -f osv-dpdk`
#DPDK's Target
export RTE_TARGET=x86_64-native-osvapp-gcc
#OSv's Folder
export OSV_SDK=`readlink -f osv`
```

After setting environment variables and initializing submodules ->
```
cd osv-dpdk
#Checkout OSv branch
git checkout osv-head
#Compile
make install T=$RTE_TARGET OSV_SDK=$OSV_SDK
```

A folder with the target name will be generated with the necessary library. Copy this library to [binary](./binary) ->
```
cp -fa x86_64-native-osvapp-gcc/lib/libintel_dpdk.so ../binary
```

### Click

With DPDK's and OSv's environment variables already defined, initialized submodules and compiled DPDK library ->
```
cd click
#If there is an old build, clean it
make clean
#Configure click to compile with DPDK, OSv and fPIC (for shared libraries) support
./configure --enable-dpdk --enable-osv --enable-user-multithread --disable-linuxmodule CXXFLAGS="-fPIC -std=gnu++11" CFLAGS="-fPIC" LDFLAGS="-fPIC -std=gnu++11" CPPFLAGS="-fPIC -std=gnu++11"
#Compile userlevel application
cd userlevel
make
#Copy the generated binary to [binary](./binary) folder
cp -fa click ../../binary
```

### OSv

With DPDK and OSv compiled ->
```
#Copy binaries to OSv's modules folder
cp binary/* osv/modules/click
#Execute OSv's dependencies setup script
cd osv
./scripts/setup.py
#Compile OSv with Click and Web Interface modules
./scripts/build modules=click,httpserver-click_plugin
```

Finally, a "qcow2" image will be generated at build/last/usr.img.
Execute "scripts/gen-vbox-ova.sh" to generate an "ova".
