#!/bin/bash

#find me in /mnt/appdata/System/cargobase
#use with: rsync -i --ignore-existing root@172.16.0.182:/users/dat/mdt_10/dfue_in/telebox/iftmin_save/*.gz ./sync/ |sed 's/............//' | xargs -I+ ./sortfilekai.sh "+"


# set the base path for the destination
basepath="/mnt/appdata/System/ict/in"
#basepath="/Users/kre/Desktop/sync/sortfolder"
if [ $HOSTNAME = "Kai-Arnes-MacBook-Pro.local" ]; then
  echo "hi Kai on $HOSTNAME"
  basepath="/Users/kre/Desktop/sync/sortfolder"
fi

esburl="http://kai.requestcatcher.com/bla"

save_and_post(){
  echo $1 > "$basepath/$folder/$file" 
  curl --silent -d "$1" -H "Content-Type: text/plain" $esburl --output /dev/null
}

# store the filename
file="$1"

# get the name of the file without extension, to use for unzipping only
originalfilename=${file%.*}

# exit out of the script if the filename contains either D99A_M.edi or EDI_08A_M.edi 
case "$file" in
    *"D99A_M.edi"*) exit 1  ;;
    *"EDI_08A_M.edi"*) exit 1  ;;
esac


# identify what type of file it is, since we need to unzip the .gz, and just copy the rest.
filetype=`file --mime-type -b ./sync/"$file"`
# echo $filetype

# get the second part of the filename, seperated by underscore to get the folder into which the file needs to go.
cust=`echo "$file" | awk -F'_' '{print $2}'`




# since some of the numbers need to go into specific folder, set a variable with the foldername
case  "$cust" in
005003264)
    folder="ashland"
    ;;
079436434)
    folder="solenis"
    ;;
315000554i)
    folder="basf"
    ;;
315000554)
    folder="basf"
    ;;
*)
    folder="$cust"
    ;;

esac

# create the folder, only IF it doesn't exist ( -p )
mkdir -p "$basepath/$folder"


# now, based on the filetype we either unzip it, or just move it into the folder.
case "$filetype" in 
"text/plain")
  echo "iconv-ing text file $file"
  content=` iconv --from-code=ISO-8859-1 --to-code=UTF-8 "./sync/$file" `
  save_and_post "$content"
  ;;
"application/x-gzip")
  echo "unzipping and iconv-ing file $file"
  content=`gunzip -c "./sync/$file" | iconv --from-code=ISO-8859-1 --to-code=UTF-8` 
  save_and_post "$content"
  ;;
*)
  echo "iconv-ing unidentified file $file"
  content=` iconv --from-code=ISO-8859-1 --to-code=UTF-8 "./sync/$file" `
  save_and_post "$content"
  ;;

esac
