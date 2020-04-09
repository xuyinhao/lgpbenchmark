#!/bin/sh
cpath=`dirname $0`
cpath=`cd "${cpath}";cd "..";pwd`
nodeRets=`${cpath}/bin/nodes.sh cd "$cpath" \; java  -jar lib/benchmark-hbase.jar insert "$@"`
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
echo "@@total:${totalNum}r,time:${totalTime}ms,avg:${totalAvg}r/s"
