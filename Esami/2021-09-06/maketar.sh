# su host Linux
# dopo aver installato la chiave pubblica dell'utente dell'host
# negli account root delle varie VM
mkdir esame
cd esame

IP_ROUTER=192.168.56.202
IP_CLIENT1=192.168.56.201
IP_SERVER1=192.168.56.203
IP_SERVER2=192.168.56.204
IP_SERVERMAIN=192.168.56.205


# per ogni file da consegnare
scp $IP_ROUTER:/etc/dnsmasq.conf attivita2/router/etc/dnsmasq.conf
scp $IP_ROUTER:/etc/network/interfaces.d/eth1 attivita1/router/etc/network/interfaces.d/eth1
scp $IP_ROUTER:/etc/network/interfaces.d/eth2 attivita1/router/etc/network/interfaces.d/eth2
scp $IP_ROUTER:/etc/network/interfaces.d/eth3 attivita1/router/etc/network/interfaces.d/eth3

scp $IP_CLIENT1:/etc/network/interfaces attivita1/client/etc/network/interfaces

scp $IP_SERVER1:/etc/network/interfaces attivita1/server1/etc/network/interfaces
scp $IP_SERVER2:/etc/network/interfaces attivita1/server2/etc/network/interfaces

scp $IP_SERVERMAIN:/etc/network/interfaces attivita1/servermain/etc/network/interfaces
