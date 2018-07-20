#!/bin/bash

filepath="/mnt/appdata/System/cargobase/AP"
basepath="/mnt/appdata/System/ict/APERAK"

# if [ $HOSTNAME = "Kai-Arnes-MacBook-Pro.local" ]; then
#   echo "hi Kai on $HOSTNAME"
#   filepath="/Users/kre/Desktop/sync"
#   basepath="/Users/kre/Desktop/sync/sortfolder"
# fi

esburl="http://docker-dmz:9000/cargobasesorterap"

save_and_post(){
  echo $1 > "$basepath/$folder/$file" 
  curl --silent -d "$1" -H "Content-Type: text/plain" $esburl --output /dev/null
}

file="$1"
content=` iconv --from-code=ISO-8859-1 --to-code=UTF-8 "$filepath/$file" `
save_and_post "$content"
