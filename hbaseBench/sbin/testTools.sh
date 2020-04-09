#!/bin/sh
path=`dirname $0`
path=`cd $path;cd "..";pwd`

. "${path}/conf/conf"
. "${path}/bin/shell/common"
. "${path}/lib/log_tool.sh"

LOG_HBASE="/tmp/lgp-hbase.log"
caseConfDir="$path/conf/caseConf"

runCase(){
     #echo "2:$2"
       testcase="$path/bin/tools/$cases"
       #echo "testCase:$testcase"
       if [ -f $testcase ]; then
        ret=`. $testcase`		#1:fail, 0 :pass
	 	if [ $ret -eq 0 ];then
	        log_and_show "INFO" "$apiName.$caseName pass"
		else
	        log_and_show "ERROR" "$apiName.$caseName fail"
        fi
	   fi
}

echo_help(){
	echo "usage:"
	echo " tools_caseName"
	exit 1
}

if [ 0 -eq $# ]; then
	echo_help
elif [ 1 -eq $# ]; then
	apiName=$1              # apiName 
	if [ ! -f $path/bin/tools/"$apiName" ]; then
    	log_and_show "WARN" "apiName are prefered!"
    	log_and_show "WARN" "check $path/bin/tools/"$apiName" exist "
		echo_help
	fi
	cases=$1                # 测试的cases
#	if [ "$cases" == "" ];then
 #   	cases=`cat $caseConfDir/$apiName`       #调用testApi时用到
#	fi
else
	echo_help
fi

logTime="$(date +'%Y-%m-%d_%T')"
init_log "$LOG_HBASE"

echo "$logTime run hbaseShellTest: $apiName "$cases"" |tee -a "$LOG_HBASE"
runCase  "${cases}" 
log_and_show  "INFO" "Hbase shell $apiName test finished! Log path : $LOG_HBASE"
