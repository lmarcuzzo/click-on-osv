rm ./images/click-on-osv.img
rm ../../Share/click-on-osv.img
cd osv/
./scripts/build image=click,httpserver-click_plugin,python2x
cp build/last/usr.img ../images/click-on-osv.img
cp build/last/usr.img ../../../Share/click-on-osv.img
cd ../../../Share/
chmod 777 click-on-osv.img
