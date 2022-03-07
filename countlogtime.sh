#!/bin/sh

getdays=$(uptime | cut -d ',' -f 1 | cut -d ' ' -f 4)
gethours=$(uptime | cut -d ',' -f 2 | cut -d ':' -f 1)
getmins=$(uptime | cut -d ',' -f 2 | cut -d ':' -f 2)
if [ ! -n "$getdays" ];then
	getdays=0
	gethours=$(uptime | cut -d ',' -f 1 | cut -d ':' -f 3 | cut -d ' ' -f 4)
	getmins=$(uptime | cut -d ',' -f 1 | cut -d ':' -f 4)
fi
newtimestamp=$(date +%s)

function switch_days() {
	onedaysec="((60*60*24))"
	part1="$(($getdays*$onedaysec))"
}

function switch_hours() {
	onehoursec="((60*60))"
	part2="$(($gethours*$onehoursec))"
}

function switch_mins() {
	oneminsec="60"
	part3="$(($getmins*$oneminsec))"
}

function merge_result() {
	switch_days
	switch_hours
	switch_mins
	resultsec="$(($part1+$part2+$part3))"
}

merge_result

echo 当前uptime转换成秒数的值为：$resultsec。
#echo 设备开机日期为：$(date -d @$(($newtimestamp-$resultsec)) +%Y年%m月%d日%H时%M分)

read -p 请输入内核日志中显示的时间： kernelsecs
getdays=$(($kernelsecs/60/60/24))
gethours=$(((($kernelsecs-(($getdays*24*60*60))))/60/60))

echo -e "\n该时间表示的是从$(date -d @$(($newtimestamp-$resultsec)) +%Y年%m月%d日%H时)开始,\n\
运行了\033[40;35m$getdays天\033[0m\033[40;35m$gethours小时\033[0m后的时间点产生的事件日志。\n\
即$(date -d @$(((($newtimestamp-$resultsec))+$kernelsecs)) +%Y年%m月%d日%H时%M分)。"

