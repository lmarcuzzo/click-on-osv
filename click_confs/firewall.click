//Firewall libera ICMP e TCP que bloqueia UDP, exceto na portas 53 para um ip especifico (192.168.0.15)

wani :: FromDevice(0);
wano :: ToDevice(0);

lani :: FromDevice(1);
lano :: ToDevice(1);


    //Libera ARP e envia pacotes IP para classificar
    cw :: Classifier(
        12/0806, // Pacotes arp p/ out 0 
        12/0800, // Pacotes IP p/ out 1
        -        // Outros tipos de pacotes p out 2
    );

    //Regras IP
    f :: IPFilter(
	//Todas regras são apenas para 192.168.0.15
	deny dst host 192.168.0.15 && icmp, //Libera ICMP
	allow dst host 192.168.0.15 && tcp, //Libera TCP (d-itg precisa)
	allow dst host 192.168.0.15 && udp && dst port 53, //Libera UDP porta 53 (DNS)
	deny all
    );

wani -> cw; //Entrada WAN para classificador
cw[0] -> CheckARPHeader(14) -> lano;                  // Pacotes ARP passam direto
cw[1] -> CheckIPHeader(14) -> f;                      // Pacotes IP enviados para o IPFilter
cw[2] -> Print("Drop (Not IP or ARP Packet)") -> Discard; // Descarta
f -> lano; // Saida do filtro para rede interna
lani -> wano; //Saida da rede interna para externa
