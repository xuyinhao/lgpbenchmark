#!/bin/sh
if [ $# -ne 3 ]; then
    echo "脚本参数有误！"
    echo "请输入 文件大小 文件个数 一次写入的单词个数等三个参数"
    exit 0
fi
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

declare wordcount_filePath="/datapool/999loongoop/wordscount"
WC_LOG=/tmp/lgp-wc.log

show_log "INFO" "init pass"
##获取yarn node节点
getNode(){
#	local noder
	nodeList=`ssh $nodemaster "$loongoopPath/bin/yarn node  -list 2>/dev/null  |grep RUNNING"`
	nodeList=`echo "$nodeList"|awk -F : '{print $1}'`
	for i in $nodeList
	do
		noder=$noder" "$i
	done
	echo $noder
}

nodes=`getNode`
show_log "INFO" "yarn nodes:${nodes[@]}"
rm -rf /tmp/wcgenresult*
echo "$wordcount_filePath"
java -jar ${spath}/lib/benchmark-loongoop-x2.jar createpath "$wordcount_filePath"
java -jar ${spath}/lib/benchmark-loongoop-x2.jar createpath "/datapool/wcgenresult"

log_and_show "INFO" "cp"
index=0
for node in ${nodes[@]} ; do
 ssh $node "java -jar ${spath}/lib/benchmark-loongoop-x2.jar wordswrite $1 $2 $3 ${index} $wordcount_filePath > /tmp/lgp-wc.log  2>&1 " & 
 index=`expr ${index} + 1`
done
wait
log_and_show "INFO" "write file success" "$LINENO" "$WC_LOG"

fileExit=`${loongoopPath}/bin/hadoop fs -test -d wordcountOutput 1>/dev/null 2>&1`
if [ 0 -eq $? ]; then
  ${loongoopPath}/bin/hadoop fs -rm -R wordcountOutput 1>/dev/null 2>&1
fi
#if [ "$wordcount_filePath" != "" ];then 
#	rm -rf  `getMountPath`/${wordcount_filePath} 
#	mv /datapool/${wordcount_filePath} `getMountPath`/${wordcount_filePath} 
#else
#	log_and_show "ERROR" "no wordcount_filePath .." "$LINENO" "$WC_LOG"
#fi

log_and_show "INFO" "Run wordcount MR ...... "
${loongoopPath}/bin/hadoop jar ${exampleJarPath} wordcount -D mapreduce.job.reduces=${reduceNum}  /`basename ${wordcount_filePath}` wordcountOutput >$WC_LOG 2>&1 
if [ $? -eq 0 ];then 
	log_and_show "INFO" "MR finished" "$LINENO" "$WC_LOG"
else
	log_and_show "ERROR" "MR error.. exit now" "$LINENO" "$WC_LOG"
	exit 1
fi
rm -f ${cpath}/output 1>/dev/null 2>&1
touch ${cpath}/output 1>/dev/null 2>&1

log_and_show "INFO" "get mr wordcount result and check ..."
${loongoopPath}/bin/hadoop fs -cat "wordcountOutput/*"  > ${cpath}/output 2>&1
log_and_show ""  "`java -jar ${spath}/lib/benchmark-loongoop-x2.jar wordscheck "${cpath}/output"`" "" $WC_LOG

sh ${cpath}/bin/checkword.sh "${cpath}/output" "/datapool/wcgenresult/"

