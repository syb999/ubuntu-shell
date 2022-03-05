#!/bin/sh
a=0
for i in $(seq 0 99);do
	let i++
	a=$(expr $a + $i)
	if [ $i -lt 100 ];then
		echo -n "$(($i))+"
	else
		echo -en "$(($i))=$(echo $a)\n"
	fi
done
