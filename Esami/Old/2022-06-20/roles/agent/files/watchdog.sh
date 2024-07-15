tail -f /var/log/alerts.log | while read riga; do
    message=$(echo $riga | rev | cut -f1 -d: | rev | tr -d " ")
    if [ $message == "STOP" ]; then
        utente=$(ps axho user | grep -v root | sort | uniq -c | sort -nr | head -n 1 | awk '{print  $2}')
        read -ra array <<< "$(ps aux | grep "^$utente" | awk '{ print $2 }' | tr '\n' ' '))"
        # ps axho user,pid | grep -w ^riccardo | awk '{ print $2 }'
        for pid in "${array[@]}"; do 
            kill -9 $pid
        done    
    fi
done

ps axho user | grep -v root | sort | uniq -c | sort -nr | head -n 1 | awk '{print  $2}'