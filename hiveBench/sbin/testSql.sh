#!/bin/sh

path=`dirname $0`
path=`cd $path;cd "..";pwd`
. "${path}/conf/conf"
. "${path}/bin/common"
. "${path}/lib/log_tool.sh"
LOG_HIVE="/tmp/lgp-hive.log"
caseConfDir="$path/conf/caseConf"


runCase(){
 exist=$(echo "$1"| grep "#")
 if [ "$exist" != "" ]; then
    echo "pass $1"
  else
   if [ ! -d $path/bin/"$1" ]; then
    echo "$apiConf are prefered!"
   else
     #echo "2:$2"
     for caseName in $cases
     do
      passed=$(echo $caseName | grep "#")
      if [ "$passed" != "" ]; then
       echo "pass $apiName.$caseName"
      else
       testcase="$path/bin/$apiName/$caseName"
       #echo "testCase:$testcase"
       if [ -f $testcase ]; then
        ret=`. $testcase`
        echo "$apiName.$caseName $ret"
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
    	echo "apiName are prefered!"
    	echo "check $path/bin/"$apiName" exist "
		echo_help
    	exit 1
	fi

	cases=$2                # 测试的cases
	if [ "$cases" == "" ];then
    	cases=`cat $caseConfDir/$apiName`       #调用testSql时用到
	fi
#	 . "${path}/bin/$apiName/functions"
else
	echo_help
fi
logTime="$(date +'%Y-%m-%d_%T')"
init_log $LOG_HIVE
echo $logTime  $apiName $cases |tee -a $LOG_HIVE
runCase $apiName "${cases}" |tee -a $LOG_HIVE
