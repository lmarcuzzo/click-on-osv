# GT-FENDE: VNF Server (click-on-osv)

Este projeto têm como objetivo a execução do [Click Modular Router](https://github.com/kohler/click) no Unikernel [OSv](https://github.com/cloudius-systems/osv). O Click é compilado como uma aplicação de nível de usuário com suporte a uma versão modificada do [Intel DPDK](https://github.com/syuu1228/dpdk) executando no OSv.

## Limitações
A compilação foi testada apenas em ambiente Debian 8. Em versões superiores a 2.19 do Glib pode ocorrer um problema ao criar o link entre o binário do click e a lib do dpdk. Isto pode ser verificado executando o comando ```ldd -d click``` no binário do click. Deve aparecer uma biblioteca libintel_dpdk.so

Também é necessário que a versão do GCC seja superior a versão 4.8.


## Uso

Uma versão pré-compilada está disponível para download como um disco "qcow2" ou como uma appliance "ova" para VirtualBox. Estas imagens e instruções podem ser encontradas em [images](./images).


## Compilação:

O script build.sh realiza a compilação do DPDK, do Click e do OSv e disponibiliza na pasta **binary** a biblioteca do DPDK (*libintel_dpdk.so*) e o binário do Click (*click*), além de uma imagem em (*images*). Configurações de exemplo podem ser encontradas na pasta [click_confs](click_confs)

Antes de iniciar a compilação, é necessário baixar todos os submodulos, executando o comando na pasta raiz:
```
git submodule update --init --recursive
```


## DPDK
Para a compilação do DPDK:

Na pasta raiz, iniciar ou atualizar todos os submódulos e definir as variáveis de ambiente para compilação:

```
#Diretório do DPDK
export RTE_SDK=`readlink -f osv-dpdk`
#Target do DPDK
export RTE_TARGET=x86_64-native-osvapp-gcc
#Diretório do OSv
export OSV_SDK=`readlink -f osv`

```
Após isso, dentro do diretório do DPDK:
```
cd osv-dpdk
#Fazer checkout da branch do OSv
git checkout osv-head
#Compilar
make install T=$RTE_TARGET OSV_SDK=$OSV_SDK
```

Será gerada uma pasta com o nome do target que possui a biblioteca necessária. Copiar ela para [binary](./binary)
```
cp -fa x86_64-native-osvapp-gcc/lib/libintel_dpdk.so ../binary
```
## Click
Com as variáveis de ambiente do DPDK e do OSv definidas, e com o DPDK já compilado, dentro da pasta do Click:

```
cd click
#Limpar build (se houver)
make clean
#Configurar click para compilar com suporte ao DPDK, OSv, e fPIC (para shared library)
./configure --enable-dpdk --enable-osv --enable-user-multithread --enable-local --enable-wifi --disable-linuxmodule CXXFLAGS="-fPIC -std=gnu++11" CFLAGS="-fPIC" LDFLAGS="-fPIC -std=gnu++11" CPPFLAGS="-fPIC -std=gnu++11"
#Refazer lista de elementos
make elemlist
#Compilar aplicação userlevel
cd userlevel
make
#Copiar o binário gerado para a pasta "binary"
cp -fa click ../../binary
```

## OSv
Para compilar o OSv, é necessário ter compilado o Click e o DPDK:

```
#Copiar binarios para pasta de módulos do OSv
cp binary/* osv/modules/click
#Executar script para instalar as dependências do OSv
cd osv
./scripts/setup.py
#Inicializar submodulos
git submodule update --init --recursive
#Compilar OSv com os módulos do Click e da interface web
./scripts/build modules=click,httpserver-click_plugin
```
No fim, será gerada uma imagem qcow2 em build/latest/usr.img.
Para gerar um .ova, executar "scripts/gen-vbox-ova.sh"

Mais informações sobre a compilação e execução do OSv podem ser encontradas na página do [OSv](https://github.com/cloudius-systems/osv).
