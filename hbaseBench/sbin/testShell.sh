#!/bin/sh
# 执行 hbase shell 测试的脚本
# 

filename="testShell.sh" 	#脚本名称
path=$(cd `dirname $0`;cd "..";pwd)
if [ "${path}/../global.conf" ];then
	. "${path}/../global.conf"
fi
. "${path}/lib/log_tool.sh"
. "${path}/conf/conf"
. "${path}/bin/common"

caseConfDir="$path/conf/caseConf"

if [ "x$LOG_HBASE" == "x" ];then
    LOG_HBASE="/tmp/lgp-hbase.log"
fi

runCase(){
 	exist=$(echo "$1"| grep "#")
 	if [ "$exist" != "" ]; then
    	log_and_show "INFO" "Skip:  $1"
	else
		if [ ! -d $path/bin/shell/"$1" ]; then
    		log_and_show "INFO" "$apiConf are prefered!"
   		else
     		for caseName in $cases
     		do
      			passed=$(echo $caseName | grep "#")
      			if [ "$passed" != "" ]; then
       				log_and_show "INFO" "pass $apiName.$caseName"
      			else
       				testcase="$path/bin/shell/$apiName/$caseName"
       				if [ -f $testcase ]; then
        				ret=`. $testcase`		#1:fail, 0 :pass
	 					if [ $ret -eq 0 ];then
	        				log_and_show "INFO" "$apiName.$caseName pass"
						else
	        				log_and_show "ERROR" "$apiName.$caseName fail"
							syslog "lgptest_hbase" "$filename" "1" "$apiName.$caseName fail"
        				fi
	   				fi
	  			fi
     		done
   		fi
 	fi
}

echo_help(){
	echo "usage:"
	echo " <shellName> [caseName]"
	exit 1
}

if [ 0 -eq $# ]; then
	echo_help
elif [ 1 -eq $# -o 2 -eq $# ]; then
	apiName=$1              # apiName 
	if [ ! -d $path/bin/shell/"$apiName" ]; then
    	log_and_show "WARN" "apiName are prefered!"
    	log_and_show "WARN" "check $path/bin/shell/"$apiName" exist "
		echo_help
	fi
	cases=$2                # 测试的cases
	if [ "$cases" == "" ];then
    	cases=`cat $caseConfDir/$apiName`       #调用testApi时用到
	fi
else
	echo_help
fi

logTime="$(date +'%Y-%m-%d_%T')"
init_log "$LOG_HBASE"

echo "$logTime run hbaseShellTest: $apiName "$cases"" |tee -a "$LOG_HBASE"
runCase $apiName "${cases}" 
