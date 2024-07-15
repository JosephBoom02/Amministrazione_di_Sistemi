cat /var/log/newusers | while read username; do
    mkdir /home/"$username" -m=0755
    chown "$username":"$username" /home/"$username"

    if [[ $(hostname) =~ '^client*' ]]; then 
        priv=$(snmpget -v 1 -c public 10.11.11.1 NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\""$username"_PRIV\")
        pub=$(snmpget -v 1 -c public 10.11.11.1 NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\""$username"_PUB\")

        touch /home/"$username".ssh/id_rsa
        touch /home/"$username".ssh/id_rsa.pub

        cat $priv > /home/"$username".ssh/id_rsa
        cat $pub > /home/"$username".ssh/id_rsa.pub
    else 
        pub=$(snmpget -v 1 -c public 10.22.22.1 NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\""$username"_PUB\")
        echo $pub >> /home/"$username".ssh/authorized_keys
    fi
done