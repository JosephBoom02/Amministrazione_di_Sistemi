while :
do
    cache=$(free -Lh | cut -f16 -d' ')
    free=$(free -Lh | cut -f33 -d' ')
    tupla=$(ps aux --sort=-%cpu | awk 'NR==2{print $1,$2,$11}')
    echo "Ram free: $(( $cache + $free )) \t Most cpu consuming process: $tupla" | /usr/bin/logger -p "local1.=info"
done

