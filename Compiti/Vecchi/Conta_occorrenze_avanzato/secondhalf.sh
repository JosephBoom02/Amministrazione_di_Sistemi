#$1 è il numero di righe

function handler(){
    echo "Processo secondhalf interrotto!"
    echo "Numero di occorrenze trovate: $(cat /tmp/secondresult)"
    echo $(cat /tmp/secondresult) > /tmp/partial
}


trap handler USR1
echo "PID processo secondhalf: $$"
echo $$ > /tmp/secondhalf #scrivo il pid in un file 


TOT=0

tail -n $1 The_Adventures_Of_Sherlock_Holmes.txt | grep -o -i 'sherlock' | while read R; do
    TOT=$(( $TOT + 1 ))
    echo $TOT > /tmp/secondresult
done

ps $(cat /tmp/firsthalf) >> /dev/null
if [ $? -eq 0 ]; then
    kill -s USR1 $( cat /tmp/firsthalf ) 2>>/dev/null
fi 


