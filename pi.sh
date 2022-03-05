#!/bin/sh
echo 开始计算圆周率PI
read -p 请输入计算精度（至少500）: pitimes
starttime=$(date +%s)
thenum=0
n=1
m=$(expr $n + 2 )
for i in $(seq 1 $pitimes);do
	thea=$(echo $(awk -v x=1 -v y="$n" 'BEGIN{printf "%.20f\n",x/y}') | sed 's/[0][0]*$//g')
	theb=$(echo $(awk -v x=1 -v y="$m" 'BEGIN{printf "%.20f\n",x/y}') | sed 's/[0][0]*$//g')
	theresult=$(echo $(awk -v x="$thea" -v y="$theb" 'BEGIN{printf "%.15f\n",x-y}') | sed 's/[0][0]*$//g')
	thenum=$(echo $(awk -v x="$thenum" -v y="$theresult" 'BEGIN{printf "%.15f\n",x+y}'))
	n=$(expr $m + 2 )
	m=$(expr $n + 2 )
done
thepi=$(echo $(awk -v x=4 -v y="$thenum" 'BEGIN{printf "%.20f\n",x*y}') | sed 's/[0][0]*$//g')
endtime=$(date +%s)
usetime=$(expr $endtime - $starttime)
usetmins=$(expr $usetime / 60)
usehours=$(expr $usetmins / 60)
usemins=$(expr $usetmins - $(expr $usehours \* 60))
usesecs=$(expr $usetime - $(expr $usetmins \* 60))
if [ $usemins -lt 10 ];then
	usemins="0${usemins}"
fi
if [ $usesecs -lt 10 ];then
	usesecs="0${usesecs}"
fi
echo 圆周率结果:$thepi
echo 计算用时: ${usehours}小时${usemins}分${usesecs}秒

