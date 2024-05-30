declare -a files
files=($(ls /var/log | grep -e '^my.log.[0-9].bz2'))

echo "Contenuto di files: ${files[@]}"

for ((i=${#files[@]}-1; i>=0; i--)); do 
    IFS="." read -ra newfile_split <<< "${files[$i]}"
    ##"${newfile_split[2]}" contiene il numero da incrementare

    sudo mv "/var/log/${files[$i]}" "/var/log/${newfile_split[0]}"."${newfile_split[1]}".$(( "${newfile_split[2]}" + 1 ))."${newfile_split[3]}"
done