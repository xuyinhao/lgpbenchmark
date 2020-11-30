#!/bin/sh

path=`dirname $0`
path=`cd $path;cd "..";pwd`

# conf,log
if [ "${path}/../global.conf" ];then
    . "${path}/../global.conf"
fi
. "${path}/conf/conf"
. "${path}/bin/common"
. "${path}/lib/log_tool.sh"

if [ "x$LOG_HIVE" == "x" ];then
	LOG_HIVE="/tmp/lgp-hive.log"
fi

caseConfDir="$path/conf/caseConf"
init_log $LOG_HIVE

runCase(){
 exist=$(echo "$1"| grep "#")
 if [ "$exist" != "" ]; then
    log_and_show "INFO" "Skip $1"
  else
   if [ ! -d $path/bin/"$1" ]; then
    log_and_show "INFO" "$apiConf are prefered!"
   else
     #echo "2:$2"
     for caseName in $cases
     do
      passed=$(echo $caseName | grep "#")
      if [ "$passed" != "" ]; then
       log_and_show "INFO" "Skip $apiName.$caseName"
      else
       testcase="$path/bin/$apiName/$caseName"
       #echo "testCase:$testcase"
       if [ -f $testcase ]; then
        ret=`. $testcase`
		if [ $ret -eq 0 ];then
	        log_and_show "INFO" "$apiName.$caseName pass"
		else
	        log_and_show "ERROR" "$apiName.$caseName fail"
       fi
      fi
	 fi
    done
   fi
 fi
}

echo_help(){
	echo "usage:"
	echo " <sqlName> [caseName]"
	exit 1
}

if [ 0 -eq $# ]; then
	echo_help
elif [ 1 -eq $# -o 2 -eq $# ]; then
	apiName=$1              # apiName 
	if [ ! -d $path/bin/"$apiName" ]; then
    	log_and_show "WARN"  "apiName are prefered!"
    	log_and_show "WARN"  "check $path/bin/"$apiName" exist "
		echo_help
    	exit 1
	fi

	cases=$2                # 测试的cases
	if [ "$cases" == "" ];then
    	cases=`cat $caseConfDir/$apiName`       #调用testSql时用到
	fi
else
	echo_help
fi
cases_rev="$(echo $cases|xargs)"
logTime="$(date +'%Y-%m-%d_%T')"
log_and_show "INFO" "$logTime  $apiName $cases_rev"
runCase $apiName "${cases}" 
