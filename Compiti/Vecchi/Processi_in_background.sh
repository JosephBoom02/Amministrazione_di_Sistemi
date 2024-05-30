sleep 10 &
jobs1=$!
sleep 20 &
jobs2=$!
while [ 1 = 1 ]; do
echo "Aspetto 5 secondi e controllo i processi"
sleep 5
ps $jobs1 1>>/dev/null
if [[ $? -eq 0  ]]; then #se ps restituisce 0 vuol dire che il processo sleep 10 è ancora in esecuzione
echo "Il comando sleep 10 è ancora in esecuzione"
else echo "Il comando sleep 10 è terminato"
fi
ps $jobs2 1>>/dev/null
if [[ $? -eq 0  ]]; then #se ps restituisce 0 vuol dire che il processo sleep 20 è ancora in esecuzione
    echo "Il comando sleep 20 è ancora in esecuzione"
else echo "Il comando sleep 20 è terminato"
fi

done