#!/bin/sh
path=`dirname $0`
path=`cd $path;cd "..";pwd`

. "${path}/conf/conf"
. "${path}/bin/tools/common"
. "${path}/lib/log_tool.sh"

LOG_HBASE="/tmp/lgp-hbase.log"
caseConfDir="$path/conf/caseConf"
totalcasenum=0
passnum=0

runCase(){
	let totalcasenum+=1
	testcase="$path/bin/tools/$cases"
       
	if [ -f $testcase ]; then
        ret=`. $testcase`		#1:fail, 0 :pass
	 	if [ $ret -eq 0 ];then
	        log_and_show "INFO" "Tools.$apiName pass"
			let passnum+=1
		else
	        log_and_show "ERROR" "Tools.$apiName fail"
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
    	log_and_show "WARN" "toolName are prefered!"
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

log_and_show "INFO" "run hbaseTools: Tools $apiName"
runCase  "${cases}" 
echo totalnum:$totalcasenum , passnum:$passnum
#log_and_show  "INFO" "Hbase shell $apiName test finished! Log path : $LOG_HBASE"
