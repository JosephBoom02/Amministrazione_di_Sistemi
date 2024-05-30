#Scrivere uno script bash che dato il file allegato conti le occorrenze:

#    della lettera 'a'
#    della parola 'sherlock' case insensitive
#    per ogni parola distinta conti le sue occorrenze e mostri a terminale le cinque parole con frequenza maggiore
#

a=`grep -o '[a]' 'The_Adventures_Of_Sherlock_Holmes.txt' | wc -l`

echo "Le occorrenze del carattere 'a' sono $a"

sherlock=`grep -o -i 'sherlock' 'The_Adventures_Of_Sherlock_Holmes.txt' | wc -l`

echo "Le occorrenze della parola 'sherlock' sono $sherlock"

paroledistinte=`grep -o -E '\w+' The_Adventures_Of_Sherlock_Holmes.txt | sort | uniq -c | sort -g -r | head -n5`

echo "Elenco parole distinte:"
echo "$paroledistinte"