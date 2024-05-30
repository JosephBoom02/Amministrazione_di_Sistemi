function sum() { 
    echo debug: initial A=$A
    echo debug: increment of $1
    (( A+=$1 ))
    echo debug: final A=$A
}
A=0
sum 5

# produce l'output di debug


echo $A

# A è stato incrementato di 5


echo 20 | sum $(cat)

# produce l'output di debug, da cui risulta l'incremento di 20

echo $A

# A non è cambiato: la pipeline ha causato l'esecuzione di sum in un processo separato