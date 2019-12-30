#!/bin/bash
c1path=`dirname $0`
c1path=`cd "${c1path}";cd ..;pwd`

#  100g * nodes_num , 50 files * nodes_num 
$c1path/wordcount/bin/wordcount.sh $((100*1024*1024*1024)) 50 1000 


