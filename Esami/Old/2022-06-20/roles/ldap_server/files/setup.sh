#!/bin/bash

# nodi strutturali
ldapsearch -x -b "ou=People,dc=labammsis" -s base > /dev/null || 
	ldapadd -x -H ldap:/// -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -f /tmp/people.ldif

ldapsearch -x -b "ou=Groups,dc=labammsis" -s base > /dev/null ||
	ldapadd -x -H ldap:/// -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -f /tmp/groups.ldif

ldapsearch -x -b "ou=People,dc=labammsis" -s "uid=temp" > /dev/null || 
	dapadd -x -H ldap:/// -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -f /tmp/temp.ldif

ldapsearch -x -b "ou=People,dc=labammsis" -s "cn=temp" > /dev/null || 
	ldapadd -x -H ldap:/// -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -f /tmp/temp_group.ldif