#!/bin/bash

if [ $# -ne 2 ];then echo "no path . need 2 path: outFile genresultPath" ;exit 1 ;fi
outPath=$1
genresultPath=$2
cpath=`dirname $0`
cpath=`cd "${cpath}";cd "..";pwd`
spath=`dirname $0`
spath=`cd "${spath}";cd "../..";pwd`
if [ ! -f ${cpath}/../conf/conf ]; then
    echo "conf is not exist !" |tee -a $WC_LOG
    exit 0
fi
. ${cpath}/bin/common
. ${cpath}/../conf/conf
. ${cpath}/../lib/log_tool.sh


rm -rf ${cpath}/o2
for word in `cat ${outPath}|awk '{print $1}'`
do
 m=0;for i in `cat ${genresultPath}/gen* |grep "^$word "|awk  '{print $2}'`;do let m+=$i;done ; echo -e "${word}\t${m}"  >>${cpath}/o2
done

ret=`diff ${cpath}/o2 ${outPath}`
if [ $? -eq 0 ];then
	log_and_show "INFO" "check pass"
else
	log_and_show "ERROR" "Check Error ..."
fi


