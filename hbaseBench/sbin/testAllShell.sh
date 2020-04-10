#!/bin/sh
spath=`dirname $0`
path=`cd $spath;cd "..";pwd`
caseConfDir="${path}/conf/caseConf"
apiConf=`cat ${path}/conf/shellConf`
for apiName in $apiConf
do
  exist=`echo "$apiName"| grep "#"`
  if [ "$exist" != "" ]; then
    echo "Skip hbaseshell test:${apiName#\#}"
  else
#    echo "run api $apiName"
    cases=`cat $caseConfDir/$apiName`
    #echo $cases
    ${spath}/testShell.sh $apiName "$cases"
  fi
done
