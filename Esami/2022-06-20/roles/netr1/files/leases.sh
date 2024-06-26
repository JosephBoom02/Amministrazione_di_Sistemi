DHCPLEASE="/var/lib/misc/dnsmasq.leases"

while read -r ID MACADDRESS IPv4 HOSTNAME IPv6 ; do 
	logger -p local1.info -n 10.200.1.1 "$IPv4"
done < "$DHCPLEASE"