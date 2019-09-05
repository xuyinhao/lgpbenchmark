#!/bin/sh
cpath=`dirname $0`
cpath=`cd "${cpath}";cd "..";pwd`
if [ ! -f ${cpath}/conf/conf ]; then
    echo "conf is not exist !"
    exit 0
fi
. ${cpath}/conf/conf
begin=`date '+%s%N'`
ret=`${hbasePath} org.apache.hadoop.hbase.mapreduce.RowCounter $1 2>&1 | grep ROWS=`
end=`date '+%s%N'`
time=`expr \( $end - $begin \) / 1000000`
count=${ret##*ROWS=}
echo "@@time:${time}ms,count:${count}r"
