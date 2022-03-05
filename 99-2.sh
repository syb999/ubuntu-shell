#!/bin/sh
# 打印99乘法表-2
for i in $(seq 1 9)
do
	for j in $(seq 1 9)
	do
		a=$(expr $i \* $j)
		if [ $a -lt 10 ];then
			#a="0$a"
			a=$(printf "%2s" $a)
		fi
		if  [ $i -eq 1 -a $j -eq 1 ];then
			echo -n "$i*$j=$a  "
		elif  [ $j -gt 1 ];then
			if [ $i -gt $j ];then
				echo -n ""
			elif [ $j -eq 9 ];then
				echo "$i*$j=$a  "
			elif [ $i -eq 2 -a $j -eq 1 ];then
				echo "$i*$j=$a  "
			else
				echo -n "$i*$j=$a  "
			fi
		else
			if [ $i -gt $j ];then
				echo -n ""
			else
				echo "$i*$j=$a  "
			fi
		fi 
	done
done
