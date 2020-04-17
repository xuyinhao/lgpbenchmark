#!/bin/bash
cpath=$(cd `dirname $0`;pwd)
spath=$cpath/sbin


sh $spath/testShell.sh create 1-1

sh $spath/testTools.sh hbasepe
