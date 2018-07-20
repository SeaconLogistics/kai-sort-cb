#!/bin/bash

#find me in /mnt/appdata/System/cargobase
#use with: rsync -i --ignore-existing root@172.16.0.182:/users/dat/mdt_10/dfue_in/telebox/iftmin_save/*.gz ./sync/ |sed 's/............//' | xargs -I+ ./sortfilekai.sh "+"

filepath="/mnt/appdata/System/cargobase/AP"
# set the base path for the destination
basepath="/mnt/appdata/System/ict/APERAK"
#basepath="/Users/kre/Desktop/sync/sortfolder"
if [ $HOSTNAME = "Kai-Arnes-MacBook-Pro.local" ]; then
  echo "hi Kai on $HOSTNAME"
  filepath="/Users/kre/Desktop/sync"
  basepath="/Users/kre/Desktop/sync/sortfolder"
fi

esburl="http://kai.requestcatcher.com/bla"

save_and_post(){
  echo $1 > "$basepath/$folder/$file" 
  curl --silent -d "$1" -H "Content-Type: text/plain" $esburl --output /dev/null
}

# store the filename
file="$1"

content=` iconv --from-code=ISO-8859-1 --to-code=UTF-8 "$filepath/$file" `

save_and_post "$content"
