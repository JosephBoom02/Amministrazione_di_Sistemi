function handle_ctrlc()
{
    kill "${pid[@]}"
    exit
}

trap handle_ctrlc SIGINT

echo "Lancio i seguenti comandi contemporaneamente: $@"
declare -A pid #creo un dizionario in cui inserisco le coppie comando-pid
for comm in "$@"; do
    $comm &
    pid[$comm]=$!
done
echo "${pid[@]}" #stampa di debug della lista dei pid

ps "${pid[@]}" 1>>/dev/null
while [ $? -eq 0 ]; do
    sleep 5
    for comm in "$@"; do
    ps "${pid[$comm]}" 1>>/dev/null
    if [[ $? -eq 0 ]]; then #se ps restituisce 0 vuol dire che il processo è ancora in esecuzione
        echo "Il comando $comm è ancora in esecuzione"
        echo "Il comando $comm è ancora in esecuzione" >> log
    else echo "Il comando $comm è terminato" ; echo "Il comando $comm è terminato" >> log
    fi
    done
    ps "${pid[@]}" 1>>/dev/null
done
