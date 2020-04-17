#!/bin/sh
# hbase tools(MR) 测试主脚本
#

filename="testTools.sh"
path=$(cd `dirname $0`;cd "..";pwd)

if [ "${path}/../global.conf" ];then
    . "${path}/../global.conf"
fi
. "${path}/lib/log_tool.sh"
. "${path}/conf/conf"
. "${path}/bin/common"
. "${path}/bin/tools/func"

if [ "x$LOG_HBASE" == "x" ];then
	LOG_HBASE="/tmp/lgp-hbase.log"
fi
caseConfDir="$path/conf/caseConf"

runCase(){
	#let totalcasenum+=1
	testcase="$path/bin/tools/$cases"
       
	if [ -f $testcase ]; then
        ret=`. $testcase`		#1:fail, 0 :pass
	 	if [ $ret -eq 0 ];then
	        log_and_show "INFO" "Tools.$apiName pass"
		else
	        log_and_show "ERROR" "Tools.$apiName fail"
			syslog "lgptest_hbase" "$filename" "1" "Tools.$apiName fail"
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
else
	echo_help
fi

logTime="$(date +'%Y-%m-%d_%T')"
init_log "$LOG_HBASE"

runCase  "${cases}" 
