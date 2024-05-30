function firsthandler(){
    echo "Processo firsthalf interrotto!"
    echo "Numero di occorrenze trovate: $(cat /tmp/firstresult)"
    echo $(cat /tmp/firstresult) > /tmp/partial
}

function secondhandler(){
    echo "Processo secondhalf interrotto!"
    echo "Numero di occorrenze trovate: $(cat /tmp/secondresult)"
    echo $(cat /tmp/secondresult) > /tmp/partial
}

function firsthalf {
    trap firsthandler USR1
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
}

function secondhalf {
    trap secondhandler USR2
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
}

num=`wc -l The_Adventures_Of_Sherlock_Holmes.txt | cut -f1 -d" "`
if [ $(( $num % 2 )) -eq 1 ]; then
    firsthalf=$(( num / 2 + 1 ))
    secondhalf=$(( num / 2 ))
else firsthalf=$(( num / 2 )) ; secondhalf=$(( num / 2 ))
fi

echo "Numero di righe da leggere: $firsthalf $secondhalf"

firsthalf $firsthalf &
secondhalf $secondhalf &

wait

echo "Numero totale di occorrenze: $(( `cat /tmp/firstresult` + `cat /tmp/secondresult` ))"