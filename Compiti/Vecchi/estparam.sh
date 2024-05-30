dir=$1
echo "Primo parametro: $dir"
shift
if [ -d "$dir" ] && echo "Directory $dir"
then
    ext="$@"
    echo "Estensioni da cercare: "
    echo "${ext[@]}"
    ext_search="$1|"
    shift
    for str in "$@"; do ext_search="$ext_search$str|"; done
    ext_search=`echo $ext_search | rev | cut -c2- | rev`
    echo "$ext_search"
    ls -R / 2>/dev/null | egrep "\.("$ext_search")$" | rev | cut -f1 -d. | rev | sort |uniq -c
else echo "Inserire una directory"
fi
