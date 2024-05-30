#!/bin/bash
# Se il carico del sistema è inferiore ad una soglia specificata 
# come primo parametro dello script, lancia il comando specificato
# come secondo parametro.
# Altrimenti, con at, rischedula il test dopo 2 minuti, e procede
# così finchè non riesce a lanciare il comando.

# configurazione del nome dello script
# come si può ricavare automaticamente senza ambiguita'
# dovute a path relativi che potrebbero confondere atd?
THIS=$(pwd)/niceexec_esteso.sh

if [[ $# -lt 5 ]]; then 
    echo "Lanciare il comando con la sintassi:"
    echo "niceexec_esteso.sh -n MAX_TENTATIVI -s SOGLIA_CARICO  COMANDO_DA_ESEGUIRE  PARAMETRI"
    exit 1
fi

OPTSTRING=":n:s:"

while getopts ${OPTSTRING} opt; do
  case ${opt} in
    n)
      echo "Option -n was triggered, argument: ${OPTARG}"
      MAX_TENTATIVI=${OPTARG}
      ;;
    s)
      echo "Option -s was triggered, argument: ${OPTARG}"
      SOGLIA_CARICO=${OPTARG}
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done



# testare se $MAX_TENTATIVI è un numero
if ! [[ "$MAX_TENTATIVI" =~ ^[0-9]+$ ]] ; then
	echo "$MAX_TENTATIVI non è un numero"
	exit 1
fi

# testare se $SOGLIA_CARICO è un numero
if ! [[ "$SOGLIA_CARICO" =~ ^[0-9]+$ ]] ; then
	echo "$SOGLIA_CARICO non è un numero"
	exit 1
fi



COMANDO_DA_ESEGUIRE=$5
PARAMETRI=$6

# $COMANDO_DA_ESEGUIRE deve essere eseguibile, file standard e con path assoluto 
# per evitare problemi con l'environment di atd
if ! [[ -x "$COMANDO_DA_ESEGUIRE" && -f "$COMANDO_DA_ESEGUIRE" && "$COMANDO_DA_ESEGUIRE" =~ ^/ ]] ; then
	echo "$COMANDO_DA_ESEGUIRE" non è un eseguibile con path assoluto
	exit 1
fi

# ipotesi semplificativa: solo la parte intera del carico a 1 minuto
# per farlo, devo sapere qual è il delimitatore dei decimali 
# in accordo alla localizzazione attiva: man locale
LOAD=$(uptime | awk -F 'average: ' '{ print $2 }' | cut -f1 -d$(locale decimal_point))
if test $LOAD -lt "$SOGLIA_CARICOat" ; then
	eval "$COMANDO_DA_ESEGUIRE $PARAMETRI"
else
    if [[ $MAX_TENTATIVI = 0 ]]; then
        exit 1
    else echo $THIS "$1" $(( $MAX_TENTATIVI - 1 )) "$3 $4 $5 $6" | at now +2 minutes
    fi
fi