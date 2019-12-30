#!/bin/bash
c1path=`dirname $0`
c1path=`cd "${c1path}";cd ..;pwd`

#  100M * nodes_num , 4 files 
$c1path/wordcount/bin/wordcount.sh $((100*1024*1024)) 4 1000 


