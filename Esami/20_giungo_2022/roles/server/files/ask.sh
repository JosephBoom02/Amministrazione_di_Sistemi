#!/bin/bash

while true ; do 
	read -p "Username: " USERNAME
	[[ $USERNAME =~ [^a-z] ]] || {
		echo "Solo caratteri minuscoli"
		break
	}

	LDAP_OUTPUT=$(ldapsearch -x -LLL -H 10.200.1.254 -w gennaio.marzo -b "uid=$USERNAME,ou=Users,dc=labammsis" -s base | grep '^dn' )
done
LDAP_GROUPS=$(ldapsearch -x -LLL -H 10.200.1.254 -w gennaio.marzo -b "cn=*,ou=Groups,dc=labammsis" -s base | grep '^cn' | awk -F 'cn= ' '{ print $2 }')

echo "Gruppi disponibili:"
echo "$LDAP_GROUPS"

while true ; do 
	read -p "Gruppo: " GRUPPO
	echo "$LDAP_GROUPS" | grep -Fxq "$GRUPPO" && break
done

user=$(mktemp)

USERID=$(ldapsearch -x -LLL -H 10.200.1.254 -w gennaio.marzo -b "uid=*,ou=Users,dc=labammsis" -s base | grep '^uidNumber' | awk -F 'uidNumber: ' '{ print $2 }' | sort -nr | head -n 1) 
USERID=(( $USERID + 1 ))

USERGID=$(ldapsearch -x -LLL -H 10.200.1.254 -w gennaio.marzo -b "cn=$GRUPPO,ou=Groups,dc=labammsis" -s base | grep '^gidNumber' | awk -F 'gidNumber: ' '{ print $2 }') 

echo "dn: uid=$USERNAME,ou=People,dc=labammsis
objectClass: top
objectClass: posixAccount
objectClass: shadowAccount
objectClass: inetOrgPerson
givenName: $USERNAME
cn: $USERNAME
sn: $USERNAME
uid: $USERNAME
uidNumber: $USERID
gidNumber: $USERGID
homeDirectory: /tmp
loginShell: /bin/bash
userPassword: {crypt}x" >> $user
ldapadd -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H "ldap://10.100.1.254" -f $user

[[ "$?" == 0 ]] && {
	PASSWORD=$(tr -dc '0-9' < /dev/urandom | head -c 10)
	ldappasswd -D "cn=admin,dc=labammsis" -w "gennaio.marzo" "uid=$USERNAME,ou=People,dc=labammsis" -s "$PASSWORD" && 
	echo "utente $USERNAME con $PASSWORD creato con successo"
}

