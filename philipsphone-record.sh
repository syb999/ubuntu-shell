#!/bin/sh

deviceinfo=$(arecord -l | grep PHILIPS)
cardnum=$(echo $deviceinfo | cut -d ':' -f 1 | cut -d ' ' -f 2)
devnum=$(echo $deviceinfo | cut -d ':' -f 2 | cut -d ',' -f 2 | cut -d ' ' -f 3)
timeinfo=$(date | sed 's/ //g;s/CST//g;s/:/时/;s/:/分/')
filename="录音记录-${timeinfo}秒.wmv"

arecord -D hw:$cardnum,$devnum -r8000 -fS16_LE /data/$filename
