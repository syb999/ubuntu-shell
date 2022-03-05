#!/bin/sh
# 打印99乘法表-1
i=1
j=1
while [ $i -lt 10 ]
do
	while [ $j -lt 10 ]
	do
		a=$((i*j))
		if [ $a -lt 10 ];then
			a=$(printf "%2s" $a)
		fi
		[ $j -le $i ] &&  echo -n "$j*$i=$a  "
		let j++
	done
	let i++
	let j=1
	echo ""
done
