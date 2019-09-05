#!/bin/sh
cpath=`dirname $0`
cpath=`cd "${cpath}";cd "..";pwd`
java -jar ${cpath}/lib/benchmark-hbase.jar column -a $1 $2
nodeRets=`${cpath}/bin/nodes.sh cd "$cpath" \; java -jar lib/benchmark-hbase.jar column -v "$@"`
#handle rets
total=0
totalTime=0
for ret in ${nodeRets} ; do
  #echo $ret
  arr=(${ret//:/ })
  arr2=(${arr[1]//@/ })
  if [ "${arr2[0]}" -gt "$totalTime" ] ; then
   totalTime=${arr2[0]}
  fi
  total=`expr $total + ${arr2[1]}`
done
avg=`expr $total \* 1000 / $totalTime`
echo "@@total:${total}r,time:${totalTime}ms,avg:${avg}r/s"
