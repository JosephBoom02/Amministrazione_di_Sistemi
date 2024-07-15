#!/bin/bash

function check_client(){
	## $1 ip del client
	snmpget -v 1 -c public $1 .1.3.6.1.4.1.2021.10.101 | grep -qi "Load Average too high" && logger -n "$1" -p local5.info "STOP"
}

PREFIX="10.100."
for HOSTID in 2.{1..255} {3..6}.{0..255} 7.{0..254} ; do
	check_client "$PREFIX$HOSTID"  & 
done  