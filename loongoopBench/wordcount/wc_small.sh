#!/bin/bash
c1path=`dirname $0`
c1path=`cd "${c1path}";cd ..;pwd`

#  20M * nodes_num , 4 files * nodes_num
$c1path/wordcount/bin/wordcount.sh $((20*1024*1024)) 4 1000 


