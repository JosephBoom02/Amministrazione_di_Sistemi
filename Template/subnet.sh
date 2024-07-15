#!/bin/bash

# Funzione per convertire una netmask in un prefisso
netmask_to_prefix() {
    local mask=$1
    local count=0
    IFS=. read -r m1 m2 m3 m4 <<< "$mask"
    for octet in $m1 $m2 $m3 $m4; do
        case $octet in
            255) count=$((count + 8));;
            254) count=$((count + 7));;
            252) count=$((count + 6));;
            248) count=$((count + 5));;
            240) count=$((count + 4));;
            224) count=$((count + 3));;
            192) count=$((count + 2));;
            128) count=$((count + 1));;
            0) ;;
            *) echo "Netmask non valida"; exit 1;;
        esac
    done
    echo $count
}

# Lettura degli argomenti IP e netmask
ip=$1
mask=$2

# Verifica del formato dell'indirizzo IP e della netmask
if ! echo "$ip" | grep -Eq '([0-9]{1,3}\.){3}[0-9]{1,3}'; then
    echo "Indirizzo IP non valido"
    exit 1
fi

if ! echo "$mask" | grep -Eq '([0-9]{1,3}\.){3}[0-9]{1,3}'; then
    echo "Netmask non valida"
    exit 1
fi

# Separazione degli ottetti di IP e netmask
IFS=. read -r i1 i2 i3 i4 <<< "$ip"
IFS=. read -r m1 m2 m3 m4 <<< "$mask"

# Calcolo della subnet, broadcast, primo e ultimo IP
network="$((i1 & m1)).$((i2 & m2)).$((i3 & m3)).$((i4 & m4))"
broadcast="$((i1 & m1 | 255-m1)).$((i2 & m2 | 255-m2)).$((i3 & m3 | 255-m3)).$((i4 & m4 | 255-m4))"
first_ip="$((i1 & m1)).$((i2 & m2)).$((i3 & m3)).$(((i4 & m4)+1))"
last_ip="$((i1 & m1 | 255-m1)).$((i2 & m2 | 255-m2)).$((i3 & m3 | 255-m3)).$(((i4 & m4 | 255-m4)-1))"
prefix=$(netmask_to_prefix "$mask")

# Output dei risultati
echo "network:   $network/$prefix"
echo "broadcast: $broadcast"
echo "first IP:  $first_ip"
echo "last IP:   $last_ip"
