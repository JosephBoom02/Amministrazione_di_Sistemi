#!/bin/bash

if [[ $# -ne "1" ]]; then 
	echo "Inserire un nome utente"
	exit 1

while true ; do
	read -p "Password: " PASSWORD
    echo "Lunghezza: "${#PASSWORD}
    if [ ${#PASSWORD} -lt 6 ]; then
        echo "Inserire una password di almeno 6 caratteri"
		continue
    fi

	break
done

echo "Password: $PASSWORD"
username=$1

user=$(mktemp) 
echo "dn: uid=dave,ou=People,dc=labammsis
objectClass: top
objectClass: posixAccount
objectClass: shadowAccount
objectClass: inetOrgPerson
givenName: $username
cn: $username
sn: $username
uid: $username
uidNumber: $userid
gidNumber: $userid
homeDirectory: /home/dave
loginShell: /bin/bash
userPassword: {crypt}x" >> $user
ldapadd -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H "ldap://10.100.1.254" -f $user

ldappasswd -D "cn=admin,dc=labammsis" -w "gennaio.marzo" "uid=$USERNAME,ou=People,dc=labammsis" -s "$PASSWORD" && 
	echo "utente $USERNAME con $PASSWORD creato con successo"

ssh-keygen -t rsa -b 2048 -f /home/vagrant/keys/$username

## mando username e chiave a ogni server
## i server si trovano in un range di indirizzi 192.168.1.129 - 192.168.1.254
PREFIX="192.168.1."
for HOSTID in {129..254} ; do
	logger -p local2.warning -n "$PREFIX$HOSTID" "$username $(cat /home/vagrant/keys/$username.pub)"
done

## mando username e chiave a ogni client
## i server si trovano in un range di indirizzi 172.20.8.1 - 172.20.15.254
PREFIX="172.20."
for HOSTID in 8.{1..255} {9..14}.{0..255} 15.{0..254} ; do
	logger -p local2.warning -n "$PREFIX$HOSTID" "$username $(cat /home/vagrant/keys/$username.pub)"
done

echo "extend $username /usr/bin/cat /home/vagrant/keys/$username" >> /etc/snmp/snmpd.conf