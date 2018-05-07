#!/usr/bin/env bash

status=""

while read -r line
do
    host=$(cut -d, -f1 <<< $line)
    display_name=$(cut -d, -f2 <<< $line)
    type=$(cut -d, -f3 <<< $line)

    case "$type" in
    "ping")
        /usr/bin/fping -u "$host" >& /dev/null
        if [ $? -eq 0 ]; then
            status+="$display_name\${alignr}\${color6}PASS\${color}\n"
        else
            status+="$display_name\${alignr}\${color8}FAIL\${color}\n"
        fi
        ;;
    "http")
        if curl --head -s --request GET "$host" | grep -E "200 OK|301" > /dev/null; then
            status+="$display_name\${alignr}\${color6}PASS\${color}\n"
        else
            status+="$display_name\${alignr}\${color8}FAIL\${color}\n"
        fi
        ;;
    esac
done < check-hosts

echo -e "\${voffset 12}$status"
exit
