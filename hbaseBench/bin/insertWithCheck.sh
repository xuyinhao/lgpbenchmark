#!/bin/sh
cpath=`dirname $0`
cpath=`cd "${cpath}";cd "..";pwd`
if [ ! -f ${cpath}/conf/conf ]; then
    echo "conf is not exist !"
    exit 0
fi
. ${cpath}/conf/conf
java -jar ${cpath}/lib/benchmark-hbase.jar insert -dc $1 $5
nodeRets=`${cpath}/bin/nodes.sh cd "$cpath" \; java -jar ${cpath}/lib/benchmark-hbase.jar insertWithCheck "$@"`
echo "$nodeRets"
