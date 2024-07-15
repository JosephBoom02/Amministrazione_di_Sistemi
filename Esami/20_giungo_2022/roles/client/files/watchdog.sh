#!/bin/bash

cat /var/log/alerts.log | while read riga ; do
	[[ $riga == "STOP" ]] && {
		user=ps aux | grep -v '^root' | sort | awk '{ print $1 }' | uniq -c | sort -nr | awk '{ print $2 }' | head -n 1
		ps aux | grep "^$user" | awk '{ print $2 }' | while read pid ; do 
			kill -s SIGKILL "$pid"
		done
	}
done