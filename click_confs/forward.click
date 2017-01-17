//Forward entre portas 0 e 1 do Click (VM precisa ser criada com 3 portas, sendo uma para gerencia e as outras para o forward)
FromDPDKDevice(0) -> ToDPDKDevice(1);
FromDPDKDevice(1) -> ToDPDKDevice(0);

