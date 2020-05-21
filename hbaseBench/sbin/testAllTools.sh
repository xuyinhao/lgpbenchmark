#!/bin/sh
spath=`dirname $0`
path=`cd $spath;cd "..";pwd`
caseConfDir="${path}/conf/caseConf"
apiConf=`cat ${path}/conf/toolsConf|xargs`
. ${path}/lib/log_tool.sh


log_and_show  "INFO" "hbaseToolsTest start $apiConf"
for apiName in $apiConf
do
  exist=`echo "$apiName"| grep "#"`
  if [ "$exist" != "" ]; then
    show_log "INFO"  "Skip tools test: ${apiName#\#}"
  else
    ${spath}/testTools.sh $apiName
  fi
done
