#!/bin/sh
cpath=`dirname $0`
cpath=`cd "${cpath}";cd "..";pwd`
nodeRets=`${cpath}/bin/nodes.sh cd "$cpath" \; java -jar lib/benchmark-hbase.jar update "$@"`
totalTime=0
queryMaxTime=0
queryTotalTime=0
querySum=0
updateSum=0
for ret in ${nodeRets} ; do
  arr=(${ret//:/ })
  arr2=(${arr[1]//@/ })
  if [ "${arr2[0]}" -gt "$totalTime" ] ; then
    totalTime=${arr2[0]}
  fi
  if [ "${arr2[1]}" -gt "$queryMaxTime" ] ; then
    queryMaxTime=${arr2[1]}
  fi
  queryTotalTime=`expr $queryTotalTime + ${arr2[2]}`
  querySum=`expr $querySum + ${arr2[3]}`
  updateSum=`expr $updateSum + ${arr2[4]}`
done
queryAvgTime=`expr $queryTotalTime / $querySum`
queryAvg=`expr $querySum \* 1000 / $totalTime`
updateAvg=`expr $updateSum \* 1000 / $totalTime`
echo "@@total:${2}r,time:${totalTime}ms,updateSum:${updateSum}r,updateAvg:${updateAvg}r/s,querySum:${querySum}r,queryAvg:${queryAvg}r/s,maxDelay:${queryMaxTime}ms,avgDelay:${queryAvgTime}ms"
