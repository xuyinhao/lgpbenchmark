#!/bin/sh
path=`dirname $0`
path=`cd $path;cd "..";pwd`

. "${path}/conf/conf"
. "${path}/bin/shell/common"
. "${path}/lib/log_tool.sh"

LOG_HBASE="/tmp/lgp-hbase.log"
caseConfDir="$path/conf/caseConf"

runCase(){
 exist=$(echo "$1"| grep "#")
 if [ "$exist" != "" ]; then
    log_and_show "INFO" "Skip:  $1"
  else
   if [ ! -d $path/bin/shell/"$1" ]; then
    log_and_show "INFO" "$apiConf are prefered!"
   else
     #echo "2:$2"
     for caseName in $cases
     do
      passed=$(echo $caseName | grep "#")
      if [ "$passed" != "" ]; then
       log_and_show "INFO" "pass $apiName.$caseName"
      else
       testcase="$path/bin/shell/$apiName/$caseName"
       #echo "testCase:$testcase"
       if [ -f $testcase ]; then
        ret=`. $testcase`		#1:fail, 0 :pass
	 	if [ $ret -eq 1 ];then
	        log_and_show "ERROR" "$apiName.$caseName fail"
		else
	        log_and_show "INFO" "$apiName.$caseName pass"
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
log_and_show  "INFO" "Hbase shell $apiName test finished! Log path : $LOG_HBASE"
