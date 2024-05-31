if [[ $# -lt 4 ]]; then
    echo "Sintassi: failkill.sh -f FILE -s SOGLIA"
fi


OPTSTRING=":f:s:"

while getopts ${OPTSTRING} opt; do
  case ${opt} in
    f)
      echo "Option -f was triggered, argument: ${OPTARG}"
      FILE=${OPTARG}
      ;;
    s)
      echo "Option -s was triggered, argument: ${OPTARG}"
      SOGLIA=${OPTARG}
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

for host in $(cat $FILE) ; do
    echo "Checking host $host"
    val=$(bash failcount.sh $host | rev | cut -f1 -d: | rev | tr -d ' ')
    if [[ $val -gt $SOGLIA ]]; then
        ssh -o "StrictHostKeyChecking no" $host "sudo systemctl poweroff"
    fi
done
