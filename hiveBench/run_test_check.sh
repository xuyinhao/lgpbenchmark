export exec="hive"
echo "------ bin/hive test"
sh sbin/testSql.sh create 0-1
echo "------ bin/hive beeline"
export exec="beeline"
sh sbin/testSql.sh create 0-1

