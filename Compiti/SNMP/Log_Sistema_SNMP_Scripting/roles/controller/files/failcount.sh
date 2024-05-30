#!/bin/bash

IP_REGEX="^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

if [[ $1 =~ $IP_REGEX ]]; then
    num=$(snmpget -v 1 -c public $1 NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"grep_failed\" | rev | cut -f1 -d: | rev | tr -d ' ')
    echo "FAILED count: $num"
else
  echo "Invalid IPv4 address: $1"
  exit 1
fi