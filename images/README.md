# Instalação:
Dentro desta pasta, existem duas imagens précompiladas, sendo uma delas um disco qcow2 que pode ser importado no KVM através do comando virt-install e uma appliance OVA para instação no VirtualBox.

## Instalação no KVM

O seguinte comando instala a VM com o nome de click-on-osv, 512 Mb de ram, 1 vcpu e duas placas de rede paravirtualizadas virtio conectadas (uma delas para gerência e uma para o Click) a rede padrão do hypervisor (normalmente virbr0).

Esta configuração pode ser alterada depois utilizando [virsh edit](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Administration_Guide/sect-Managing_guest_virtual_machines_with_virsh-Editing_a_guest_virtual_machines_configuration_file.html) para adicionar outra interface de rede, por exemplo. Para que as interfaces de rede sejam identificadas pelo OSv, é necessário que sejam do tipo **virtio**.

Nota-se que o parâmetro **--disk path=** deve ser alterado para o local onde a imagem se encontra no servidor.

>sudo virt-install --import --noreboot --name=click-on-osv --ram=512 --vcpus=1 --disk path=/home/leonardo/click-on-osv.qemu,bus=virtio --os-variant=none --accelerate --network=network:default,model=virtio --network=network:default,model=virtio --serial pty --cpu host --rng=/dev/random

## Instalação no VirtualBox
>Por problemas de compatibilidade do OSv, a VM funciona apenas na versão 4.x do VirtualBox. A versão 5.x não é suportada

Para instalar a imagem no VirtualBox, primeiro adicione uma rede exclusiva de hospedeiro no VirtualBox (se não existir). Após isso, importe o arquivo .ova para o VirtualBox e entre nas configurações de rede da VM.
O Adaptador 1 é a placa que será usada para gerência. Conecte ele a interface exclusiva de hospedeiro,e defina o tipo de placa como **virtio**. Os outros adaptadores serão utilizados pelo Click, então podem estar conectados a outras placas, desde que estejam com o tipo de placa como **virtio** e o modo promíscuo em *Permitir Tudo*.

# Utilização

Após a VM ser instalada, o console dela deve ser acessado para identificar o endereço IP de gerência.
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
No caso acima, o IP é 192.168.100.211. Assim a interface web pode ser acessada através de http://192.168.100.211:8000

### Interface WEB
A interface Web do click é uma extensão da interface do OSv, sendo assim é criada uma nova aba com as funções utilizads pelo Click. Caso o módulo do Click não tenho sido selecionado na build do OSv, esta interface não estará disponível. Ao acessar a aba do Click, o usuário têm acesso a informações sobre a VNF que está sendo executada, controle sobre o ciclo de vida da VM e da VNF, estatísticas de uso, editor para a função que está instalada e upload de novas funções, e um log de execução do Click.

#### Controle do ciclo de vida:
Através da interface, o usuário têm acesso ao ciclo de vida, tanto da VM como da VNF, sendo capaz de inicializar, parar e reiniciar a VNF, e reiniciar ou desligar a VM.

#### Estatísticas e informações da VNF:
É possível
