#!/bin/sh
if [ $# -le 0 ];then
	echo """Usage:
	$0 runlevel [runtimes]
	runtimes : default=1
	Example:
	    $0 small 
	    $0 middle 2
	    $0 big
"""
exit 1
fi

declare runlevel=$1
declare -i runtimes=$2
declare -i retNum=1

cpath=`dirname $0`
cpath=`cd "${cpath}";cd "..";pwd`
. ${cpath}/lib/log_tool.sh
. ${cpath}/conf/conf

declare retLog=${cpath}/ret/$retNum.log 

if [ -d "${cpath}/ret" ]; then
rm -rf "${cpath}/ret/"
fi
mkdir -p  "${cpath}/ret"

init_log $retLog

if [ ! -f ${cpath}/conf/conf.${runlevel} ]; then
    echo "conf/conf.${runlevel} is not exist !"
    exit 0
fi
. ${cpath}/conf/conf.${runlevel}

#echo "you can change the running param in ${cpath}/sbin/conf before start this shell!"
#read -p "to change the conf?(y/n)" sure
#if [ "${sure}" == "y" ] ; then
 #echo "please go to change the conf"
 #exit 0
#elif [ "${sure}" == "n" ] ; then
#echo "this shell will run with current conf!"
#else 
 #echo  "please input y or n !"
#exit 0
#fi

cmds=()
nodes=(${nodeList})
nodeNum=${#nodes[@]}
echo "----------------"
echo $nodes
echo $nodeNum
#insert
cmds[0]="${cpath}/bin/insert.sh ${tableName} ${rowNum} ${nodeNum} ${threadNum} ${batch}"
#echo "cmd0:${cmds[0]}"
#query 100w by IP
cmds[1]="${cpath}/bin/query.sh ${tableName} ${queryRowNum} ${nodeNum} ${threadNum} ${dirPath}"
#echo "cmds1${cmds[1]}"
#update 100w 90%update & 10%query
cmds[2]="${cpath}/bin/update.sh ${tableName} ${updateRowNum} ${nodeNum} ${queryThreadNum} ${insertThreadNum} ${dirPath}"
#echo ${cmds[2]}
#insertmore 100w
cmds[3]="${cpath}/bin/insertmore.sh ${tableName} ${moreRowNum} ${nodeNum} ${threadNum} ${batch}"
#echo ${cmds[3]}
#count
cmds[4]="${cpath}/bin/count.sh ${tableName}"
#add column add_column
cmds[5]="${cpath}/bin/column.sh ${tableName} ${columnName} ${batch}"
#insertWithCheck
cmds[6]="${cpath}/bin/insertWithCheck.sh ${iwcTableName} ${iwcRowNum} ${nodeNum} ${iwcThreadNum} ${iwcRowFamilyNum}"


#echo ${cmds[5]}
function hbaseTest {
   for(( i=0;i<${#cmds[@]};i++)); do
   cmd=${cmds[i]}
	log_and_show "INFO" "Run cmd: $cmd " 
	log_and_show "INFO" "Cmd result: `$cmd`\n" 
  done
  log_and_show "INFO"  "${retNum} times is finished see the logs in ret/${retNum}.log"
  retNum=`expr ${retNum} + 1`
  retLog=${cpath}/ret/${retNum}.log
 init_log $retLog
 }

if [ 0 -lt ${runtimes} ];then
	log_and_show "INFO" "this hbase test will run ${runtimes} times,please wait..."
	t=1
		while [ $t -le  $runtimes ]
		do
			hbaseTest
			t=`expr ${t} + 1`
		done
else
	log_and_show "INFO" "this hbase test will run just one time"
	hbaseTest
fi
