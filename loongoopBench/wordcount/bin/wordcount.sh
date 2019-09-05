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
if [ ! -f ${cpath}/conf/conf ]; then
    echo "conf is not exist !"
    exit 0
fi
. ${cpath}/conf/conf
nodes=(${nodeList})
`java -jar ${spath}/lib/benchmark-loongoop.jar createPath`

index=0
for node in ${nodes[@]} ; do
 ssh $node "`java -jar ${spath}/lib/benchmark-loongoop.jar wordswrite $1 $2 $3 ${index} ` 1>/dev/null  2>&1 &"
 index=`expr ${index} + 1`
done
wait
echo "write file success"
fileExit=`${loongoopPath}/bin/hadoop fs -test -d wordcountOutput 1>/dev/null 2>&1`
if [ 0 -eq $? ]; then
  `${loongoopPath}/bin/hadoop fs -rm -R wordcountOutput 1>/dev/null 2>&1`
fi
`${loongoopPath}/bin/hadoop jar ${exampleJarPath} wordcount -D mapreduce.job.reduces=${reduceNum}  ${wordcount_filePath} wordcountOutput`
`rm -f ${cpath}/output 1>/dev/null 2>&1`
`touch ${cpath}/output 1>/dev/null 2>&1`
`${loongoopPath}/bin/hadoop fs -cat wordcountOutput/* > ${cpath}/output 1>/dev/null 2>&1`
echo "`java -jar ${spath}/lib/benchmark-loongoop.jar wordscheck`"
