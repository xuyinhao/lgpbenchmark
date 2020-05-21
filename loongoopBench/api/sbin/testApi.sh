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
. "${path}/../lib/fail_retry.sh"
BASE_CASE_NAME="api"

caseConfDir="$path/conf/caseConf"
failFilePath="${path}/conf/.failretry/failitem.$BASE_CASE_NAME"
resultNumPath="${path}/conf/.resultnum/failnum.$BASE_CASE_NAME"
mkdir -p `dirname $resultNumPath`;		#初始化结果路径
API_LOG="/tmp/lgp-api.log"
if [ "x$LOG_API" != "x" ];then
	API_LOG="$LOG_API"
fi
init_log $API_LOG
log_and_shows(){
	log_and_show "$1" "$2" "" "$API_LOG"
}

## __增加失败的case记录
add_fail_item(){
    local f_item="$1"
    add_retry_item "$BASE_CASE_NAME" "$f_item"
}
## __删除失败case记录
del_fail_item(){
    local f_item="$1"
    del_retry_item "$BASE_CASE_NAME" "$f_item"
}
#失败记录到文件
fail_record(){
	local item_v="$1"
##fail retry
	if [ "x$failRetryNum" == "x" ] ;then
		return 0
	else
		add_fail_item "$item_v"
	fi
}

#失败记录删除
fail_record_del(){
	local item_v="$1"
	##fail retry
	if [ "x$failRetryNum" == "x" ] ;then
    	return 0
	else
    	del_fail_item "$item_v" > /dev/null 2>&1 
	fi
}
TOTAL_NUM=0 ; PASS_NUM=0 ;FAIL_NUM=0 ; SKIP_NUM=0 
mountPath=$(getMountPath)

runCase(){
 casekey="$1"
 caseid="$2"
 exist=$(echo "$casekey"| grep "#")
 if [ "$exist" != "" ]; then
    #echo "pass $1"
	log_and_shows "INFO" "Skip : $casekey" 
  else
   if [ ! -d $path/bin/"$casekey" ]; then
    log_and_shows "WARN" "$apiConf are prefered!"
   else
     #echo "2:$2"
     for caseName in $caseid
     do
      passed=$(echo $caseName | grep "#")
      if [ "$passed" != "" ]; then
		let TOTAL_NUM+=1 ; let SKIP_NUM+=1
		log_and_shows "INFO" "Skip case: $casekey.$caseName"
      else
		let TOTAL_NUM+=1
       testcase="$path/bin/$casekey/case/$caseName"
       if [ -f $testcase ]; then
        ret=`. $testcase`	#1:true-success, 0:false-fail
		if [ $ret -eq 1 ] ;then
    		fail_record_del "$casekey $caseName"
			let PASS_NUM+=1
	        log_and_shows "INFO" "$casekey.$caseName pass"
    	else
			fail_record "$casekey $caseName"
			let FAIL_NUM+=1
			log_and_shows "ERROR" "$casekey.$caseName fail"
			
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

##重新跑失败的case
fail_case_retry(){
##fail retry
if [ "x$failRetryNum" == "x" ] ;then
    return 0
else
	OLDIFS="$IFS"   #以换行符作为标识，而不是空格。
    IFS=$'\n'
	failcaseNum="`cat ${path}/conf/.failretry/failitem.api|wc -l`"
	IFS="$OLDIFS"   #还原
	if [ $failcaseNum -eq 0 ];then return 0;fi
	for i in $(seq 1 $failRetryNum)
	do
		OLDIFS="$IFS"   #以换行符作为标识，而不是空格。
	    IFS=$'\n'

		for failcase in `cat ${path}/conf/.failretry/failitem.api`
		do
			IFS="$OLDIFS"	#还原
		#	cat ${path}/conf/.failretry/failitem.api
 			clearTmpDir $tmpDir
			clearDir $apiPath
			log_and_shows "INFO" "Run failed case: $failcase , $i times."
			runCase $failcase
		done
done
fi

}

##begin run
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
    	cases="`cat $caseConfDir/$apiName|xargs` "       #调用testApi时用到
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
cases_rev="$(echo $cases|xargs)"
echo  "$logTime"  Run case :"$apiName" "$cases_rev" |tee -a "$API_LOG"

clearTmpDir $tmpDir
clearDir $apiPath
runCase $apiName "${cases}" 
fail_case_retry $failRetryNum
echo "$TOTAL_NUM" "$PASS_NUM" "$FAIL_NUM" "$SKIP_NUM" > $resultNumPath
#log_and_shows  "INFO" "Api $apiName test finished! Log path : $API_LOG" 
