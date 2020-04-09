#!/bin/sh
cpath=`dirname $0`
cpath=`cd "${cpath}";cd "..";pwd`
nodeRets=`${cpath}/bin/nodes.sh cd "$cpath" \; java -jar lib/benchmark-hbase.jar query "$@"`
totalTime=0
maxTime=0
sumTime=0
for ret in ${nodeRets} ; do
  arr=(${ret//:/ })
  arr2=(${arr[1]//@/ })
  if [ "${arr2[0]}" -gt "$totalTime" ] ; then
    totalTime=${arr2[0]}
  fi
  if [ "${arr2[1]}" -gt "$maxTime" ] ; then
    maxTime=${arr2[1]}
  fi
  sumTime=`expr $sumTime + ${arr2[2]}`
done
avgTime=`expr $sumTime / $2`
avg=`expr ${2} \* 1000 / $totalTime`
echo "@@total:${2}r,time:${totalTime}ms,avg:${avg}r/s,maxDelay:${maxTime}ms,avgDelay:${avgTime}ms"
