#!/bin/sh
if [ $# -ne 3 ]; then
    echo "  脚本参数有误！"
    echo "  请输入 文件大小/(每个节点)  文件个数/(每个节点)  一次写入的单词个数 三个参数"
	echo """Example: 
	$0  1024000 4 1000
	如果Yarn node 有3个节点，则会生成 12个文件，总大小为3M左右。			
	 """
    exit 0
fi
cpath=`dirname $0`
cpath=`cd "${cpath}";cd "..";pwd`
spath=`dirname $0`
spath=`cd "${spath}";cd "../..";pwd`
if [ ! -f ${spath}/conf/conf ]; then
    echo "conf is not exist !" |tee -a $WC_LOG
    exit 0
fi
. ${spath}/lib/common
. ${spath}/conf/conf
. ${spath}/lib/log_tool.sh
lgpMountPoint=`getPathNoMountpoint`		#loongoop 路径

declare wordcount_filePath="${lgpMountPoint}/wordscount"
WC_LOG=/tmp/lgp-wc.log

init_log $WC_LOG
show_log "INFO" "----------------------------------"
show_log "INFO" "Start wordcount test ... init  pass"
##获取yarn node节点
getNode(){
	nodeList=`ssh $nodemaster "$loongoopPath/bin/yarn node  -list 2>/dev/null  |grep RUNNING"`
	nodeList=`echo "$nodeList"|awk -F : '{print $1}'`
	for i in $nodeList
	do
		noder=$noder" "$i
		nodenum+=1
	done
	echo $noder
}

nodes=`getNode`
show_log "INFO" "yarn nodes:${nodes[@]}"
show_log "INFO" "每个节点写入总文件大小:${1}B,每个节点文件数:${2}"

## 初始化文件路径
log_and_show "INFO"  "the path of words : $wordcount_filePath"
log_info "`java -jar ${spath}/lib/benchmark-loongoop-x2.jar createpath "$wordcount_filePath"`" "$LINENO" "$WC_LOG"
log_info "`java -jar ${spath}/lib/benchmark-loongoop-x2.jar createpath "/datapool/wcgenresult"`" "$LINENO" "$WC_LOG"  	#固定的java程序genresult路径 ,不可更改


## 各节点执行 java 写文件
index=0
log_and_show "INFO" "begin write file ......" "$LINENO" "$WC_LOG"
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


## 执行MR wordcount
log_and_show "INFO" "Run wordcount MR ...... "
${loongoopPath}/bin/hadoop jar ${exampleJarPath} wordcount -D mapreduce.job.reduces=${reduceNum}  /`basename ${wordcount_filePath}` wordcountOutput >$WC_LOG 2>&1 
if [ $? -eq 0 ];then 
	log_and_show "INFO" "MR finished" "$LINENO" "$WC_LOG"
else
	log_and_show "ERROR" "MR error.. exit now" "$LINENO" "$WC_LOG"
	exit 1
fi


## 清 . java check
log_and_show "INFO" "get mr wordcount result and check ..."
rm -f ${cpath}/.output 1>/dev/null 2>&1
touch ${cpath}/.output 1>/dev/null 2>&1
${loongoopPath}/bin/hadoop fs -cat "wordcountOutput/*"  > ${cpath}/.output 2>/dev/null
log_and_show ""  "`java -jar ${spath}/lib/benchmark-loongoop-x2.jar wordscheck "${cpath}/.output"`" "" $WC_LOG

# shell check
log_and_show "INFO" "shell check result"
sh ${cpath}/bin/checkword.sh "${cpath}/.output" "/datapool/wcgenresult/"
