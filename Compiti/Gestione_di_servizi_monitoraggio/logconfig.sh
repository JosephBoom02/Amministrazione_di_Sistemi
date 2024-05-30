declare -A facility
facilities=(kern user mail daemon auth syslog lpr news uucp cron authpriv ftp ntp log clock local0 local1 local2 local3 local4 local5 local6 local7)

declare -A priority
priorities=(emerg alert crit err warning notice info debug)

IFS="." read -ra dot_split <<< "$1" #divido il primo parametro con il punto
facility="${dot_split[0]}"
priority="${dot_split[1]}"

echo "Facility: $facility"
echo "Prority: $priority"


if ! [[ ${facilities[@]} =~ "$facility" ]]; then 
    echo Il primo parametro deve essere una stringa nel formato facility.priority
    exit 1
fi

if ! [[ ${priorities[@]} =~ "$priority" ]]; then 
    echo Il primo parametro deve essere una stringa nel formato facility.priority
    exit 1
fi

[[ "$2" =~ ^/ ]] || {
    echo Il primo parametro deve essere un filename assoluto
    exit 2
}

T=$(mktemp)

echo -e "$1\t$2" > $T
sudo cp $T /etc/rsyslog.d/logconfig.conf
sudo systemctl restart rsyslog.service


CRONCOMMAND="/usr/bin/uptime | /usr/bin/logger -p $1"
crontab -l | grep -Fv "$CRONCOMMAND" > $T
echo "*/5 * * * * $CRONCOMMAND" >> $T
crontab $T

rm -f $T