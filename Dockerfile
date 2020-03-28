FROM ubuntu:14.04
RUN apt-get update
RUN apt-get install build-essential git python libboost-all-dev genromfs autoconf libtool ant qemu-utils maven libmaven-shade-plugin-java python-dpkt tcpdump gdb qemu-system-x86 gawk gnutls-bin openssl python-requests p11-kit g++-multilib libssl-dev libedit-dev curl libvirt-bin libncurses5-dev libyaml-cpp-dev nano -y
EXPOSE 8000

#docker build --tag coov_dev_img:1.0 .
#docker run -d -it --name coov-dev -v "$(pwd)":/click-on-osv coov_dev_img
#docker exec -it coov-dev /bin/bash