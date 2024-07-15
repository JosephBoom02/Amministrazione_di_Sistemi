if [[ $# -ne "1" ]]; then 
	echo "Inserire un solo parametro)"
	exit 1
fi

if ! [[ -f $1 ]]; then 
	echo "Inserire nome di un file"
	exit 1
fi


egrep '^[^#].*;.*;.*$' $1 | while IFS=';' read username userid password ; do
    group=$(mktemp)
    echo "dn: cn=dave,ou=Groups,dc=labammsis
    objectClass: top
    objectClass: posixGroup
    cn: dave
    gidNumber: $gidnumber" >> $group


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
    ldapadd -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap:/// -f $user
    
    ldappasswd -D "cn=admin,dc=labammsis" -w "gennaio.marzo" "uid=$username,ou=People,dc=labammsis" -s "$password" && 
	echo "utente $username con $password creato con successo"

    ssh-keygen -t rsa -f /home/vagrant/keys/"$username"

    for ip in 10.11.11.{100..120} ; do
        logger -n $ip "$username"
    done

    for ip in 10.22.22.{100..120} ; do
        logger -n $ip "$username"
    done

    echo "extend-sh $username_PRIV echo /home/vagrant/keys/$username" >> "/etc/snmp/snmpd.conf"
    echo "extend-sh $username_PUB echo /home/vagrant/keys/$username".pub >> "/etc/snmp/snmpd.conf"
done