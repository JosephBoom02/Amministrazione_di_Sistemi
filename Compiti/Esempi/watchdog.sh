ls -R / & PID=$!
WD=$(mktemp)
echo "/bin/kill $PID" | at now +2 seconds 2>&1 | grep '^job ' | cut 




WD=$(mktemp)
function restartWatchdog() {
  if [[ -s "$WD" && "$(atq | awk '{ print $1 }')" == "$(cat $WD)" ]] ; then
    atrm $(cat $WD)
  fi
  echo "/usr/bin/shutdown -r now" | at now + 5 minutes 2>&1 | grep '^job ' | cut -f1 -d' ' > $WD
}
restartWatchdog
tail -f /var/log/event.log | while read riga ; do
    # delay restart for 5 more minutes
    restartWatchdog
    # do things
done