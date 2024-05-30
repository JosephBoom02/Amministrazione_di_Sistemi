term=$(tty)
IFS='/' read -ra tty_array <<< ${term}
term="${tty_array[2]}"

if [[ $term = "pts" ]]; then
    echo "local1.warning /var/log/my.log" > /etc/rsyslog.d/mylog.conf
    THIS=$(pwd)/logrotate.sh

    PERIODO='00 23 * * 1-5'
    echo "$PERIODO $THIS" >> /etc/crontab
else 
    declare -a files
    files=($(ls /var/log | grep -e '^my.log.[0-9].bz2'))

    echo "Contenuto di files: ${files[@]}"

    for ((i=${#files[@]}-1; i>=0; i--)); do 
        IFS="." read -ra newfile_split <<< "${files[$i]}"
        ##"${newfile_split[2]}" contiene il numero da incrementare

        sudo mv "/var/log/${files[$i]}" "/var/log/${newfile_split[0]}"."${newfile_split[1]}".$(( "${newfile_split[2]}" + 1 ))."${newfile_split[3]}"
    done

    mv /var/log/my.log /var/log/my.log.1
    bzip2 /var/log/my.log.1 
    systemctl restart rsyslogd
fi