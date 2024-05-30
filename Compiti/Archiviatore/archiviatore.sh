##File che sono stati modificati o acceduti nell'ultima settimana


#time contiene i minuti di differenza tra l'istante in cui si lancia il comando e 
#il lunedì della settimana corrente
time=$(( $(( $(date +%s) - $(date --date='last monday' +%s) )) /60))
#modificati=$(find "$1" -mtime -$time)
#acceduti=$(find "$1" -atime -$time)
#echo $(find "$1" -mtime -$time) $(find "$1" -atime -$time)

car1=$(find "$1" -cmin -$time -mmin -$time)

##File che hanno un qualsiasi bit speciale settato e non sono di proprietà dell'utente root
car2=$(find "$1" -perm /4000 -uid +0)

##File che sono di tipo text (secondo il comando file), di dimensione inferiore a 100k, e contengono la stringa DOC

car3=$(file -N "$1"/* | grep '.*.:.*text' | cut -f1 -d':' | grep DOC)

filetoarchive=$(echo $car1 $car2 $car3 | tr ' ' '\n' | sort | uniq | tail -n +2)
echo $filetoarchive
DATA=$(date +%+4Y%m%d_%H%M)

tar -T $filetoarchive -cvpf backup_$DATA.tar.gz





