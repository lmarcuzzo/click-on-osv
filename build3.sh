rm ./images/click-on-osv.img
rm ../../Share/click-on-osv.img

export OSV_SDK=`readlink -f osv`
export COOV_FOLDER=$PWD

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
cp binary/* $OSV_SDK/modules/click

cd osv/
./scripts/build image=click,httpserver-click_plugin,python2x
cp build/last/usr.img ../images/click-on-osv.img
cp build/last/usr.img ../../../Share/click-on-osv.img
cd ../../../Share/
chmod 777 click-on-osv.img
