#!/bin/sh
path=`dirname $0`
path=`cd $path;cd "..";pwd`
. "${path}/conf/conf"
. "${path}/bin/commands"
. "${path}/bin/common"
caseConfDir="$path/conf/caseConf"
mountPath=$(getMountPath)
runCase(){
 exist=$(echo "$1"| grep "#")
 if [ "$exist" != "" ]; then
    echo "pass $1"
  else
   if [ ! -d $path/bin/"$1" ]; then
    echo "$apiConf are prefered!"
   else
     #echo "2:$2"
     for caseName in $2
     do
      passed=$(echo $caseName | grep "#")
      if [ "$passed" != "" ]; then
       echo "pass $apiName.$caseName"
      else
       testcase="$path/bin/$apiName/case/$caseName"
       #echo "testCase:$testcase"
       if [ -f $testcase ]; then
        ret=`. $testcase`
        echo "$apiName.$caseName $ret"
       fi
      fi
    done
   fi
 fi
}

if [ 0 -eq $# ]; then
 echo "usage:"
 echo " <apiName> [caseName]"
elif [ 1 -eq $# ]; then
 apiName=$1
 . "${path}/bin/$apiName/functions"
 cases=`ls "$path/bin/$apiName/case"`
else
 apiName=$1
 . "${path}/bin/$apiName/functions"
 cases=$2
fi
if [ "" == "$rootPath" ] || [ "" == "$tmpDir" ]; then
 echo "rootPath and tmpDir are not set!"
 exit 0
fi
logTime="$(date +'%Y-%m-%d_%T')"
apiPath="$rootPath/$apiName"
echo $logTime  $apiName $cases |tee -a /tmp/lgp.log

clearTmpDir $tmpDir
clearDir $apiPath
runCase $apiName "${cases}" |tee -a /tmp/lgp.log
