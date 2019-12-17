#!/bin/sh
path=`dirname $0`
path=`cd $path;cd "..";pwd`
. "${path}/../conf/conf"
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
     for caseName in $cases
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

echo_help(){
	echo "usage:"
	echo " <apiName> [caseName]"
}

if [ 0 -eq $# ]; then
	echo_help
elif [ 1 -eq $# -o 2 -eq $# ]; then
	apiName=$1              # apiName 
	if [ ! -d $path/bin/"$apiName" ]; then
    	echo "apiName are prefered!"
    	echo "check $path/bin/"$apiName" exist "
		echo_help
    	exit 1
	fi

	cases=$2                # 测试的cases
	if [ "$cases" == "" ];then
    	cases=`cat $caseConfDir/$apiName`       #调用testApi时用到
	fi
	 . "${path}/bin/$apiName/functions"
else
	echo_help
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
