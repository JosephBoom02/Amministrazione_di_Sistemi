function waitfile() { 
    echo "Terzo argomento: $3"
    if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
        echo "Inserire almeno due argomenti e massimo 3"
    fi
    if [ "$1" != "ls" ] && [ "$1" != "rm" ] && [ "$1" != "touch" ]; then
        echo "Il primo argomento deve essere ls, rm o touch"
    fi
    if [ "$3" = "force" ]; then
        $1 $2
    elif [[ "$3" =~ ^[0-9]$ ]]; then
        echo "Caso in cui il terzo argomento è una cifra decimale"
        if ! [ -e "$2" ]; then 
            for int in $(seq 1 $3); do
                echo "Provo per la $int\a volta"
                sleep 1
                if [ -e "$2" ]; then
                    $1 $2
                    break
                fi
            done
        else $1 $2
        fi
    else 
        echo "Caso in cui manca il terzo argomento oppure non è una singola cifra decimale"
        if ! [ -e "$2" ]; then
            for int in {1..10..1}; do
                echo "Provo per la $int\a volta"
                sleep 1
                if [ -e "$2" ]; then
                    $1 $2
                    break
                fi
            done
        else $1 $2
        fi
    fi
}

waitfile ls ~/Documents/compito.txt 4
