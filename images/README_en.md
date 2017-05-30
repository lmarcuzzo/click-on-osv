# Installation
Inside this folder, there is a qcow2 image, which can be used to install on KVM servers (using virt-install) and a OVA appliance for use in VirtualBox.

## KVM Installation

This command installs a VM on KVM servers named click-on-osv, with 512Mb of ram, 1 vcpu and 2 virtio nics connected on the default network (usually virbr0). One interface is to be used by the management interface of OSv, while the others are used by the network function.

You can change this configuration later using [virsh edit] (https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Administration_Guide/sect-Managing_guest_virtual_machines_with_virsh-Editing_a_guest_virtual_machines_configuration_file.html). If you change or add any NICs, please make sure those are of **virtio** type.

The **--disk path=** parameter should point to image location on your server.

>sudo virt-install --import --noreboot --name=click-on-osv --ram=512 --vcpus=1 --disk path=/home/leonardo/click-on-osv.qemu,bus=virtio --os-variant=none --accelerate --network=network:default,model=virtio --network=network:default,model=virtio --serial pty --cpu host --rng=/dev/random

## VirtualBox Installation
>When using VirtualBox 5.x, there is a problem when you use more than 1 NIC, so we recommend VirtualBox 4.x, which has been tested.

For the image Installation on VirtualBox, you need first to add a host-only adapter (if it not exists already). Then, import the .ova file and enter in the VM network configuration. Adapter 1 will be used for management and should be connected to the host-only adapter. Adapters 2 to 4 can be used for the VNF, so they can be set to bridges. All adapters should have promiscuous mode enabled and type **virtio**.

## Xen Installation
Although we do not completely support it, the image can be converted and run on Xen Servers. A sample config is provided on [xen-config](./xen-config).

# Use
After installing the VM, access the console and find the management IP.

```
root@acerPC:/home/leonardo/NFV_Proj# virsh start click-on-osv ; virsh console click-on-osv
Domain click-on-osv started

Connected to domain click-on-osv
Escape character is ^]
OSv v0.24-362-g85d9b49
1 CPUs detected
Firmware vendor: SeaBIOS
bsd: initializing - done
VFS: mounting ramfs at /
VFS: mounting devfs at /dev
net: initializing - done
eth0: ethernet address: 52:54:00:d4:0f:26
...
[I/196 dhcp]: Configuring eth0: ip 192.168.100.211 subnet mask 255.255.255.0 gateway 192.168.100.1 MTU 1500
Running from /init/30-auto-00: /libhttpserver.so &!
could not load libicuuc.so.52
could not load libicui18n.so.52
could not load libicudata.so.52
could not load libssl.so.1.0.0
could not load libcrypto.so.1.0.0
/#

```
In this example, the management IP is 192.168.100.211. The web interface will be available in http://192.168.100.211:8000

### Web Interface
The Click web interface is a extension of OSv's web interface. A new tab is created with functions that can be used to control Click. Those same functions are available on the REST Api. If the Click module has not been compiled, this interface will be unavailable. In this tab, the user has access to statistics, lifecycle control, a simple VNF editor and a log from the currently running Click instance.

#### Lifecycle control:
There are functions for start, stop and reset the Click instance or the entire VM.

#### Statistics and VNF info:
There are also information on the VNF being executed (based on ETSI NFV specification), and statistics about CPU, disk, memory and NICS being used.
