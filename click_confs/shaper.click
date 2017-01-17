//Limita UDP a 500 pacotes por segundo
wani :: FromDPDKDevice(0);
wano :: ToDPDKDevice(0);

lani :: FromDPDKDevice(1);
lano :: ToDPDKDevice(1);


    //Libera ARP e envia pacotes IP para classificar
    cw :: Classifier(
        12/0806, // Pacotes arp p/ out 0 
        12/0800, // Pacotes IP p/ out 1
        -        // Outros tipos p out 2
    );

    //Regras IP
    //Aqui divide entre pacotes TCP e UDP, por d-itg utilizar TCP para controle
    f :: IPClassifier(
	udp,
	-
    );

wani -> cw; //Entrada WAN para classificador

cw[0] -> CheckARPHeader(14) -> lano;                  // Pacotes ARP passam direto
cw[1] -> CheckIPHeader(14) -> f;                      // Pacotes IP enviados para o IPFilter
cw[2] -> lano; // Resto dos pacotes

//Este elemento determina que N (100) pacotes saem p output 0 e o resto p output 1  
spl :: RatedSplitter(500);

f[1] -> lano; // Saida do filtro para rede interna
f[0] -> spl; // UDP para splitter

spl[0] -> lano; //Maximo de 100 pacotes
spl[1] -> Discard; //Resto é descartado

lani -> wano; //Saida da rede interna para externa
