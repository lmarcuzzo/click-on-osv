//VNF_HEADER
//VNF_VERSION: 1.0
//VNF_ID:b69c308a-9bde-459a-b171-fed5621cd46d
//VNF_PROVIDER:UFSM
//VNF_NAME:Simple DHCP Server
//VNF_RELEASE_DATE:2017-06-24 20-30-30
//VNF_RELEASE_VERSION:1.0
//VNF_RELEASE_LIFESPAN:2017-07-31 20-30
//VNF_DESCRIPTION: Implements a simple DHCP server

//Implements a simple DHCP server that offers only IP address.
//Based on https://raw.githubusercontent.com/kohler/click-packages/master/dhcp/conf/server.click

//Phys Port where the server will listen and send offers
input :: FromDPDKDevice(0);
output :: ToDPDKDevice(0);

//MAC from input/output port, DHCP Server IP, Lease Subnet, Lease Start and End
lease :: LeasePool(52:54:00:ea:d9:c6, 192.168.10.2, 192.168.10.0, START 192.168.10.5, END 192.168.10.245, ROUTER 192.168.10.1);
//Dois dias perdido aqui
//https://github.com/kohler/click-packages/issues/2
checker :: CheckDHCPMsg;
//Receive packet and checks if is a DHCP packet
input -> CheckIPHeader(14) -> CheckUDPHeader -> checker;

//If is not  DHCP Packet, send to output (maybe discard?)
checker[1] -> Discard();

//Classifies DHCP package accordingly.
classifier :: DHCPClassifier(discover, request, release, -);
//DHCP Packets are classified here
checker[0] -> classifier;
//Craft reponses
classifier[0] -> Print(a) -> offer :: DHCPServerOffer(lease) -> output;
classifier[1] -> Print(b) -> ack :: DHCPServerACKorNAK(lease) -> output;
classifier[2] -> Print(c) -> release :: DHCPServerRelease(lease);
//If it is a DHCP packet, but none of the above, discard
classifier[3] -> Print(d) -> sink :: Discard;
