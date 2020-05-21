#!/bin/sh
spath=`dirname $0`
path=`cd $spath;cd "..";pwd`
. ${path}/../lib/fail_retry.sh
. ${path}/../lib/log_tool.sh
caseConfDir="${path}/conf/caseConf"
apiConf=`cat ${path}/conf/apiConf`
if [ -f  "${path}/../../global.conf" ];then
. "${path}/../../global.conf"
fi

API_LOG="/tmp/lgp-api.log"
if [ "x$LOG_API" != "x" ];then
    API_LOG="$LOG_API"
fi
init_log $API_LOG

BASE_CASE_NAME="api"
resultNumPath="${path}/conf/.resultnum/failnum.$BASE_CASE_NAME"

## retry init
if [ $# -ne 0 ];then
	export   failRetryNum="$1"
	init_retry "api"
fi

add_fail_item(){
	local f_item="$1"
	add_retry_item "api" "$f_item"
}

num_total_get(){
all="`cat $resultNumPath`"
echo ${all}|awk '{print $1}'
}
num_pass_get(){
all="`cat $resultNumPath`"
echo ${all}|awk '{print $2}'
}
num_fail_get(){
all="`cat $resultNumPath`"
echo ${all}|awk '{print $3}'
}
num_skip_get(){
all="`cat $resultNumPath`"
echo ${all}|awk '{print $4}'
}

total_num=0;pass_num=0;fail_num=0;skip_num=0
##main run 
for apiName in $apiConf
do
  exist=`echo "$apiName"| grep "#"`
  if [ "$exist" != "" ]; then
    echo "pass api ${apiName#\#}"
  else
   # echo "run api $apiName"
    cases=`cat $caseConfDir/$apiName`
    #echo $cases
	if [ $# -ne 0 ];then
    	init_retry "api"
	fi
    ${spath}/testApi.sh "$apiName" "$cases" 
	show_log "INFO" "t:`num_total_get` p:`num_pass_get` f:`num_fail_get` s:`num_skip_get`"
	let total_num+=`num_total_get` ; let pass_num+=`num_pass_get`
	let fail_num+=`num_fail_get` ; let skip_num+=`num_skip_get`
  fi
done
log_and_show "INFO" "total:$total_num , p:$pass_num , f:$fail_num , s:$skip_num" "" "$API_LOG"


