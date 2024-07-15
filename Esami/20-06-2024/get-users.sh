tail -f /var/log/users.log | while read USERNAME PUBKEY; do 
    [[ -d "/home/$USERNAME" ]] || {
        mkdir "/home/$USERNAME"
        chmod 755 "/home/$USERNAME"
    }
    if [[ $(hostname) =~ ^client*  ]]; then 
        PRIVKEY=$(snmpget -v 1 -c public 172.20.0.1 'NET-SNMP-EXTEND-MIB::nsExtendOutputFull."$USERNAME"')
        touch "/home/$USERNAME/.ssh/id_rsa"
        chmod 0600 "/home/$USERNAME/.ssh/id_rsa" 

        touch "/home/$USERNAME/.ssh/id_rsa.pub"
        chmod 0644 "/home/$USERNAME/.ssh/id_rsa.pub"

        echo $PRIVKEY > "/home/$USERNAME/.ssh/id_rsa"
        echo $PUBKEY > "/home/$USERNAME/.ssh/id_rsa.pub"
    else 
        echo $PUBKEY >> /home/$USERNAME/.ssh/authorized_keys
    fi
done