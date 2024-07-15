#!/bin/bash

output=snmpwalk -v 1 -c public 10.20.20.254 NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"server\" | awk -F "STRING: " '{ print $2 }' | cut -f1 -d' '

if [[ "$output" == $(hostanme) ]]; then 
	# controllo se esiste eth2
	if [[ "$(ip a | grep eth2)" ]];then 
		#esiste, quindi non faccio nulla
	else sudo ip link add eth2 type dummy
	fi
	sudo ip a add 10.20.20.20/24 dev eth2
	bash ldap.sh "new"
else sudo ip a del 10.20.20.20/24 dev eth2
fi
