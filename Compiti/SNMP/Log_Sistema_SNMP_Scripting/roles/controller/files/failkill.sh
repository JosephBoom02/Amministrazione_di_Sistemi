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

for host in $FILE ; do 
    val=$(bash failcount.sh | rev | cut -f1 -d: | rev | tr -d ' ')
done