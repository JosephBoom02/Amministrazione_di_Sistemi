#!/bin/bash

for i in {2..7}; do
    for j in {1..254}; do
        ip="10.100.$i.$j"
        ping -c 1 $ip &> /dev/null
        if [ $? -eq 0 ]; then
            # IP raggiungibile
            res=snmpwalk -v 1 -c public $ip .1.3.6.1.4.1.2021.10.1.101
            if test -n $res; then
                # stringa non vuota: ci sono errori
                logger -p local5.info -n $ip "STOP"
            fi
        fi
    done
done


