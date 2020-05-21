#!/bin/bash
cpath=$(dirname $0)
ppath="`cd $cpath;cd ..;pwd`"
#echo $ppath

base_init(){
funcname="$1"
failResultFile="${ppath}/conf/.failretry/failitem.${funcname}"
}


init_retry(){
base_init "$1"
mkdir ${ppath}/conf/.failretry -p || exit
truncate --size 0 ${failResultFile}
}

add_retry_item(){
	base_init "$1"
	local iteminfo="$2"
	line=$(grep "^${iteminfo}$" $failResultFile)
	if [ "x$line" == "x" ];then
		echo "${iteminfo}" >> $failResultFile
		[ $? -ne 0 ] && return 1
	fi
	return 2
}

del_retry_item(){
	base_init "$1"
	local itemval="$2"
	echo $itemval
#	num=$(grep "^${itemval}$" $failResultFile -n|awk -F ":" \'{print $1}\' > /dev/null 2>&1)
	line_val=$(grep "^${itemval}$" $failResultFile -n) 
	num=$(echo "$line_val"|awk -F ":" '{print $1}')
	if [ "x$num" == "x" ];then
		return 0
	else
		sed -i "${num}d" $failResultFile > /dev/null 2>&1
	fi

}
#del_retry_item "api" "mkdir 1-1"


print_retry_item(){
echo "`cat $failResultFile`"
}

#init_path "ff"
#add_item "ff" "a1 1-1"
#add_item "ff" "a2 2-1"
#add_item "ff" "a3 3-1"
#del_item "ff" "a2 2-1"
#print_item "ff"
