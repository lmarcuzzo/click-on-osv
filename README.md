# Click on OSv

Este projeto têm como objetivo a execução do [Click Modular Router](https://github.com/kohler/click) no Unikernel [OSv](https://github.com/cloudius-systems/osv). O Click é compilado como uma aplicação de nível de usuário com suporte a uma versão modificada do [Intel DPDK](https://github.com/syuu1228/dpdk) que executa no OSv.

Além do código e um script para construir a imagem, também é disponibilizada uma imagem pronta para ser usada, case não queira realizar a build.

### Build:
O script make_binarys.sh realiza a compilação do DPDK e do Click e disponibiliza na pasta **binary** a biblioteca do DPDK (*libintel_dpdk.so*) e o binário do Click (*click*). Estes arquivos, junto com o arquivo de configuração de uma Função Virtual (test.click) são utilizados em um módulo criado para o OSv que realiza a preparaçao da imagem.

Após realizar a compilação, copie os binários para **osv/modules/click**. Dentro desta pasta encontra-se também o arquivo de configuração (**func.click**), e a linha de comando, em **module.py**, caso precise ser alterada.

Para criar a imagem, dentro do diretório do OSv **execute scripts/setup.py** para a instalação dos pacotes e **git submodule update --init --recursive** para a inicialização dos submodules. Após isso crie a imagem com **scripts/build modules=click,httpserver-click_plugin** e execute com **scripts/run -n -v**. Mais informações sobre a compilação e execução do OSv podem ser encontradas na página do [OSv](https://github.com/cloudius-systems/osv).

### Uso da imagem:

Após a criação da imagem, esta pode ser importada no KVM, onde será executada. É necessário definir pelo menos uma interface para o gerenciamento da plataforma. O comando a seguir pode ser utilizado para a criação de uma máquina virtual utilizando a imagem e com duas interfaces, uma delas para gerência e uma para ser utilizada pelo Click:

>
sudo virt-install --import --noreboot --name=osv-on-click --ram=192 --vcpus=1 --disk path=/home/leonardo/click-on-osv.qemu,bus=virtio --os-variant=none --accelerate --network=network:default,model=virtio --network=network:default,model=virtio --serial pty --cpu host --rng=/dev/random

Este comando gera uma máquina virtual com 192Mb de ram, 1 vcpu e 2 interfaces de rede. Após isso pode se acessar a interface de gerência através do ip mostrado na inicialização do OSv.

```
Connected to domain click-on-osv
Escape character is ^]
OSv v0.24
1 CPUs detected
Firmware vendor: SeaBIOS
bsd: initializing - done
VFS: mounting ramfs at /
VFS: mounting devfs at /dev
RAM disk at 0x0xffff800001d2f040 (4096K bytes)
net: initializing - done
eth0: ethernet address: 52:54:00:46:99:b9
virtio-blk: Add blk device instances 0 as vblk0, devsize=10737418240
random: virtio-rng registered as a source.
vga: Add VGA device instance
random: intel drng, rdrand registered as a source.
random: <Software, Yarrow> initialized
VFS: unmounting /dev
VFS: mounting zfs at /zfs
zfs: mounting osv/zfs from device /dev/vblk0.1
random: device unblocked.
VFS: mounting devfs at /dev
VFS: mounting procfs at /proc
program zpool.so returned 1
BSD shrinker: event handler list found: 0xffffa000016df980
	BSD shrinker found: 1
BSD shrinker: unlocked, running
[I/28 dhcp]: Waiting for IP...
[I/28 dhcp]: Waiting for IP...
[I/198 dhcp]: Server acknowledged IP for interface eth0
eth0: 192.168.100.201
[I/198 dhcp]: Configuring eth0: ip 192.168.100.201 subnet mask 255.255.255.0 gateway 192.168.100.1 MTU 1500
```
#### Upload de novas funções:
A linha de comando utilizada na imagem padrão lê o arquivo func.click para inicializar o Click, a função padrão é:

>FromDPDKDevice(0) -> Print("OK") -> Discard;

esta função apenas lê os pacotes e os imprime no console do OSv.

Outras funções podem ser encontradas em click_confs.

Para fazer o upload de outras funções, acesse a interface em

>http://ip_da_vm:8000/dashboard/swagger/

Entre em file: File API e selecione POST. Em **path-par** coloque **/func.click** e clique em browse para escolher o arquivo da função a ser adicionado. Por fim clique em **Try it Out!** e reinicie a VM. A nova função será carregada.
