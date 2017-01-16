# Click on OSv

Este projeto têm como objetivo a execução do [Click Modular Router](https://github.com/kohler/click) no Unikernel [OSv](https://github.com/cloudius-systems/osv). O Click é compilado como uma aplicação de nível de usuário com suporte a uma versão modificada do [Intel DPDK](https://github.com/syuu1228/dpdk) que executa no OSv.

Além do código e um script para construir a imagem, também é disponibilizada uma imagem pronta para ser usada, case não queira realizar a build.

### Build:
O script make_image.sh realiza a compilação do DPDK e do Click e disponibiliza na pasta **img_build** a biblioteca do DPDK (*libintel_dpdk.so*) e o binário do Click (*click*). Estes arquivos, junto com o arquivo de configuração de uma Função Virtual (test.click) são utilizados pelo [Capstan](https://github.com/cloudius-systems/capstan) para construir a imagem da plataforma.

### Uso da imagem:

Após a criação da imagem, esta pode ser importada no KVM, onde será executada. É necessário definir pelo menos uma interface para o gerenciamento da plataforma. Um exemplo de arquivo de configuração de uma função virtualizada é:

>FromDPDKDevice(0) -> Print("OK") -> Discard;

esta função apenas lê os pacotes e os imprime no console do OSv.
