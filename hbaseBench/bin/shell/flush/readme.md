#flush
1-1 创建并flush,检查leofspath数据
## ./bin/hadoop fs -ls /hbase/data/default/${tableName}/*/info 2>/dev/null|grep -v Found |wc -l
