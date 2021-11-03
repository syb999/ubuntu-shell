#!/bin/bash
#sudo apt-get update && sudo apt-get install unoconv -y

function transftpdf() {
	{
	if [ "$getwork" == "${transdoc}" ];then
		getfiles="/tmp/autolptmp.doclist"
	elif [ "$getwork" == "${transwps}" ];then
		getfiles="/tmp/autolptmp.wpslist"
	elif [ "$getwork" == "${transexc}" ];then
		getfiles="/tmp/autolptmp.exclist"
	fi

	countfiles=0
	while read LINE
	do
		countfiles=$(expr $countfiles + 1)
	done < $getfiles

	if [ $countfiles -lt "100" -a $countfiles -gt "0" ];then
		beishu=$(expr 100 / ${countfiles})
	elif  [ $countfiles -eq "0" ];then
		beishu=100
	else
		beishu=${countfiles}
	fi

	for ((i = 0 ; i <= 100 ; i += $beishu));do
		if [ ! -d "$(pwd)/$getpath/backup" ];then
			mkdir $(pwd)/$getpath/backup
		fi
		echo $i
		unoconv -f pdf "$(pwd)/$getpath/$(cat ${getfiles} | head -n 1)"
		mv "$(pwd)/$getpath/$(cat ${getfiles} | head -n 1)" "$(pwd)/$getpath/backup/"
		sed "1d" -i ${getfiles}
	done
	} | whiptail --gauge "批量转PDF中，请稍后！" 6 50 0
}

getpath=$(whiptail --inputbox 请把需批量打印文件所在的目录放置在桌面上，然后输入具体目录名: 22 40 3>&1 1>&2 2>&3)

ls $(pwd)/$getpath > /tmp/autolptmp.filelist0
cp /tmp/autolptmp.filelist0 /tmp/autolptmp.filelist
ls -l $(pwd)/$getpath | grep "^d" | sed 's/[ ][ ]*/ /g' | cut -d ' ' -f 9 > /tmp/autolptmp.findfolder

findfolder="/tmp/autolptmp.findfolder"
while read LINE
do
	sed -i "$(grep $LINE /tmp/autolptmp.filelist0 --line-number | cut -d ':' -f 1)d" /tmp/autolptmp.filelist
done < $findfolder

cat /tmp/autolptmp.filelist | grep ".doc" > /tmp/autolptmp.doclist
cat /tmp/autolptmp.filelist | grep ".wps" > /tmp/autolptmp.wpslist
cat /tmp/autolptmp.filelist | grep ".xls" > /tmp/autolptmp.exclist

getwork=""
transdoc="1."
transwps="2."
transexc="3."
lpswork="4."
lpdwork="5."
outwork="6."
while [ "${getwork}" != "${outwork}" ]
do
	pddoc=$(ls $(pwd)/$getpath | grep ".doc")
	pdwps=$(ls $(pwd)/$getpath | grep ".wps")
	pdexc=$(ls $(pwd)/$getpath | grep ".xls")
	pdpdf=$(ls $(pwd)/$getpath | grep ".pdf")

	getwork=$(whiptail --menu 批量工作\(批量转换的文件会自动转移到“backup”目录内\): 23 45 6 \
	1. WORD文件批量转PDF \
	2. WPS文件批量转PDF \
	3. EXCEL文件批量转PDF \
	4. 批量打印PDF\(单面打印\) \
	5. 批量打印PDF\(双面打印\) \
	6. 退出 3>&1 1>&2 2>&3)

	if [ "$getwork" == "${transdoc}" ];then
		if [ -n "$pddoc" ];then
			transftpdf
		fi
	fi

	if [ "$getwork" == "${transwps}" ];then
		if [ -n "$pdwps" ];then
			transftpdf
		fi
	fi

	if [ "$getwork" == "${transexc}" ];then
		if [ -n "$pdexc" ];then
			transftpdf
		fi
	fi

	if [ "$getwork" == "${lpswork}" ];then
		if [ -n "$pdpdf" ];then
			{
			for ((i = 0 ; i <= 100 ; i += 100));do
				echo $i
				lp *.pdf
			done
			sleep 3
			} | whiptail --gauge "批量打印中，请稍后！" 6 50 0
		fi
	elif [ "$getwork" == "${lpdwork}" ];then
		if [ -n "$pdpdf" ];then
			{
			for ((i = 0 ; i <= 100 ; i += 100));do
				echo $i
				lp -o sides=two-sided-long-edge *.pdf
			done
			sleep 3
			} | whiptail --gauge "批量打印中，请稍后！" 6 50 0
		fi
	fi
done
