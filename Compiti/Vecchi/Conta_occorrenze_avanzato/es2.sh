#!/bin/bash

#Eseguire lo stesso esercizio proposto sopra ma quando uno dei due processi termina prima dell'altro 
#questo deve segnalare prontamente la cosa al processo che stà ancora lavorando il quale deve gestire 
#l'interruzione interrompendo il conteggio e restituendo il risultato parziale in un file temporaneo scelto in precedenza; 
#dopo di che deve proseguire il conteggio; lo script deve restituire la somma dei due risultati parziali stampata a terminale
TOT=0
file1=$(mktemp)
file2=$(mktemp)
fileParziale=$(mktemp)

function processo(){
	echo processo "$BASHPID" interrotto
	echo "$TOT" > "$fileParziale"
}

function conta_occorrenze() {
	local quantity=0
	nomeFile="$1"
	trap processo SIGUSR1
	while IFS= read -r R ; do
		quantity=$(echo "$R" | tr '[:upper:]' '[:lower:]' | grep -o -w sherlock | wc -l)
		TOT=$((TOT+quantity))
	done < "$nomeFile"
	echo "$TOT" > "$nomeFile"
}

if [[ "$#" -ne 1 ]] ; then
	echo Deve essere 1 parametro
fi

if [[ ! -f "$1" ]] ; then
	echo File non esistente
fi

lenFile=$(wc -l < "$1")
metaLinee=$((lenFile/2))

nomeFile="$1"

head -n "$metaLinee" "$nomeFile" > "$file1"
tail -n +"$((metaLinee+1))" "$nomeFile" > "$file2"

conta_occorrenze "$file1" &
pid1="$!"
conta_occorrenze "$file2" &
pid2="$!"
wait -n
stato=`ps hp "$pid1" | awk '{print $3}'`
if test -z "$stato" ; then
echo "Il primo processo ha terminato prima del secondo."
echo "Inoltre, il secondo processo viene interrotto."
kill -SIGUSR1 "$pid2"
wait "$pid2"
else
echo "Il secondo processo ha terminato prima del primo"
echo "Inoltre, il primo processo viene interrotto"
kill -SIGUSR1 "$pid1"
wait "$pid1"
fi
# Leggi i risultati parziali
risParziale=$(cat "$fileParziale")

# Somma i valori finali di TOT1 e TOT2
TOT1=$(cat "$file1")
TOT2=$(cat "$file2")
risTotale=$((TOT1+TOT2))
echo Entrambi i processi hanno terminato
echo Il processo che è stato interrotto, al momento dell\'interruzione aveva contato "$risParziale" occorrenze
echo In totale sono state lette "$risTotale" occorrenze di sherlock
rm "$file1" "$file2" "$fileParziale" 



