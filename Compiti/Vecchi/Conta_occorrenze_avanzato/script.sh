num=`wc -l The_Adventures_Of_Sherlock_Holmes.txt | cut -f1 -d" "`
if [ $(( $num % 2 )) -eq 1 ]; then
    firsthalf=$(( num / 2 + 1 ))
    secondhalf=$(( num / 2 ))
else firsthalf=$(( num / 2 )) ; secondhalf=$(( num / 2 ))
fi

echo "Numero di righe da leggere: $firsthalf $secondhalf"

./firsthalf.sh $firsthalf &
./secondhalf.sh $secondhalf &

wait

echo "Numero totale di occorrenze: $(( `cat /tmp/firstresult` + `cat /tmp/secondresult` ))"


