#!/bin/sh
cpath=`dirname $0`
cpath=`cd "${cpath}";cd "..";pwd`
if [ ! -f ${cpath}/conf/conf ]; then
    echo "conf is not exist !"
    exit 0
fi
. ${cpath}/conf/conf
java -jar ${cpath}/lib/benchmark-hbase.jar insert -dc $1
nodeRets=`${cpath}/bin/nodes.sh cd "$cpath" \; java -jar ${cpath}/lib/benchmark-hbase.jar insert "$@"`
#handle rets
totalNum=$2
nodeNum=$3
insertNum=`expr $totalNum / $nodeNum`
totalTime=0
for ret in ${nodeRets} ; do
  arr=(${ret//:/ })
  avg=`expr $insertNum \* 1000 / ${arr[1]}`
  echo "${arr[0]}:use time ${arr[1]}ms, avg is $avg r/s"
  if [ "${arr[1]}" -gt "$totalTime" ] ; then
    totalTime=${arr[1]}
  fi
done
totalAvg=`expr $totalNum \* 1000 / $totalTime`
#handle space
spaceStr=`${hadoopPath} fs -du -s /hbase/data/default/$1`
space=${spaceStr%% *}
speed=`expr $space \* 1000 / $totalTime`
echo "@@total:${totalNum}r,time:${totalTime}ms,avg:${totalAvg}r/s,space:${space}B,speed:${speed}B/s"
