#!/bin/bash

#throw this into the crontab to sync

rsync -i --ignore-existing root@172.16.0.182:/users/dat/mdt_10/dfue_in/save/2018/AP/*.AP /mnt/appdata/system/ict/APERAK/ |sed 's/............//' | xargs -I+ /mnt/appdata/system/cargobase/sortfilekai.sh "+"
