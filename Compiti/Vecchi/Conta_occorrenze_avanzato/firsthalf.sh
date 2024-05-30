#$1 è il numero di righe

function handler(){
    echo "Processo firsthalf interrotto!"
    echo "Numero di occorrenze trovate: $(cat /tmp/firstresult)"
    echo $(cat /tmp/firstresult) > /tmp/partial
}


trap handler USR1
echo "PID processo firsthalf: $$"
echo $$ > /tmp/firsthalf #scrivo il pid in un file 


TOT=0

head -n $1 The_Adventures_Of_Sherlock_Holmes.txt | grep -o -i 'sherlock' | while read R; do
    TOT=$(( $TOT + 1 ))
    echo $TOT > /tmp/firstresult
done

ps $(cat /tmp/secondhalf) >> /dev/null
if [ $? -eq 0 ]; then
    kill -s USR1 $( cat /tmp/secondhalf ) 2>>/dev/null
fi 


