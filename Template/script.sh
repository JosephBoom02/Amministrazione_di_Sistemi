#!/bin/bash

## CHECK IF AN IP ADDRESS IS VALID
IP_REGEX="^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

if [[ $1 =~ $IP_REGEX ]]; then
  echo "Valid IPv4 address: $1"
else
  echo "Invalid IPv4 address: $1"
  exit 1
fi

## PRETTY PRINT PCAP FILE
sudo tcpdump -ttttnnr /root/out.pcap
