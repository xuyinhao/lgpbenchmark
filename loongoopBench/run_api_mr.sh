#!/bin/bash
spath=$(cd `dirname $0`;pwd)
echo $spath
. $spath/conf/conf

#sh ${spath}/api/sbin/testAll.sh 
sh ${spath}/api/sbin/testApi.sh ls 1-1
sh ${spath}/wordcount/wc_small.sh
