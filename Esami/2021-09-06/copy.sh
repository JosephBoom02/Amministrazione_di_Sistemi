#!/bin/bash

#copio la configurazione ssh di vagrant dentro quella della macchina host
vagrant ssh-config >> ~/.ssh/config

DIR="consegna"
PATH_VM="/home/vagrant"
declare -a arr=("client1" "router" "server1" "server2" "servermain")

for i in "${arr[@]}"
do
   echo "Consegno bash_history: $i"
   mkdir -p $DIR/attivita0/$i     
   scp -rp vagrant@$i:"$PATH_VM/* $PATH_VM/.bash_history" $DIR/attivita0/$i   
   
done

# copio lo script nella cartella
cp copy.sh $DIR/attivita0/

mkdir $DIR/attivita1

for i in "${arr[@]}"
do
   mkdir -p $DIR/attivita1/$i     
   
done

scp -rp vagrant@router:"/etc/network/interfaces.d/*" $DIR/attivita1/router
scp -rp vagrant@router:"/etc/dnsmasq.conf" $DIR/attivita1/router
scp -rp vagrant@client1:"/etc/network/interfaces" $DIR/attivita1/client1
scp -rp vagrant@server1:"/etc/network/interfaces" $DIR/attivita1/server1
scp -rp vagrant@server2:"/etc/network/interfaces" $DIR/attivita1/server2
scp -rp vagrant@servermain:"/etc/network/interfaces" $DIR/attivita1/servermain


tar czf ammsis.tar.gz $DIR
