#!/bin/bash
c1path=`dirname $0`
c1path=`cd "${c1path}";cd ..;pwd`

#  5G * nodes_num , 20 files  * nodes_num
$c1path/wordcount/bin/wordcount.sh $((5*1024*1024*1024)) 20 1000 


