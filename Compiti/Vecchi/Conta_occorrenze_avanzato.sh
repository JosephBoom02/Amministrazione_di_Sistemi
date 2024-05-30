
num=`wc -l The_Adventures_Of_Sherlock_Holmes.txt | cut -f1 -d" "`
if [ $(( $num % 2 )) -eq 1 ]; then
    firsthalf=$(( num / 2 + 1 ))
    secondhalf=$(( num / 2 ))
else firsthalf=$(( num / 2 )) ; secondhalf=$(( num / 2 ))
fi
head -n $firsthalf The_Adventures_Of_Sherlock_Holmes.txt | grep -o -i 'sherlock' | wc -l &
tail -n $secondhalf The_Adventures_Of_Sherlock_Holmes.txt | grep -o -i 'sherlock' | wc -l &



