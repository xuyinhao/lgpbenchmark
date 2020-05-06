#!/bin/sh
path=`dirname $0`
path=`cd $path;cd "..";pwd`

if [ -f  "${path}/../../global.conf" ];then
. "${path}/../../global.conf" 
fi
. "${path}/../conf/conf"
. "${path}/bin/commands"
. "${path}/bin/common"
. "${path}/../lib/log_tool.sh"

caseConfDir="$path/conf/caseConf"

API_LOG="/tmp/lgp-api.log"
if [ "x$LOG_API" != "x" ];then
	API_LOG="$LOG_API"
fi
init_log $API_LOG
log_and_shows(){
	log_and_show "$1" "$2" "" "$API_LOG"
}

mountPath=$(getMountPath)
runCase(){
 exist=$(echo "$1"| grep "#")
 if [ "$exist" != "" ]; then
    #echo "pass $1"
	log_and_shows "INFO" "Skip : $1" 
  else
   if [ ! -d $path/bin/"$1" ]; then
    log_and_shows "WARN" "$apiConf are prefered!"
   else
     #echo "2:$2"
     for caseName in $cases
     do
      passed=$(echo $caseName | grep "#")
      if [ "$passed" != "" ]; then
		log_and_shows "INFO" "Skip case: $apiName.$caseName"
      else
       testcase="$path/bin/$apiName/case/$caseName"
       if [ -f $testcase ]; then
        ret=`. $testcase`	#1:true-success, 0:false-fail
		if [ $ret -eq 1 ] ;then
	        log_and_shows "INFO" "$apiName.$caseName pass"
    	else
			log_and_shows "ERROR" "$apiName.$caseName fail"
	    fi
       fi
     fi
    done
   fi
 fi
}

echo_help(){
	echo "usage:"
	echo " <apiName> [caseName]"
	exit 1
}

if [ 0 -eq $# ]; then
	echo_help
elif [ 1 -eq $# -o 2 -eq $# ]; then
	apiName=$1              # apiName 
	if [ ! -d $path/bin/"$apiName" ]; then
		log_and_shows "WARN" "apiName are prefered!"
    	log_and_shows "WARN" "check $path/bin/"$apiName" exist "
		echo_help
    	exit 1
	fi

	cases="$2"                # 测试的cases
	if [ "$cases" == "" ];then
    	cases="`cat $caseConfDir/$apiName|xargs ` "       #调用testApi时用到
	fi
	 . "${path}/bin/$apiName/functions"
else
	echo_help
fi
if [ "" == "$rootPath" ] || [ "" == "$tmpDir" ]; then
 log_and_shows "ERROR" "rootPath and tmpDir are not set!"
 exit 0
fi
logTime="$(date +'%Y-%m-%d_%T')"
apiPath="$rootPath/$apiName"
echo  "$logTime  Run case :$apiName $cases"|tee -a $API_LOG
clearTmpDir $tmpDir
clearDir $apiPath
runCase $apiName "${cases}" 
log_and_shows  "INFO" "Api $apiName test finished! Log path : $API_LOG" 
