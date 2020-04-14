## shell : create  test case, create_namespace 
# 测试说明

1-1	创建1个表，1个列族
1-2 创建1个表，2个列族
1-3 创建的1个表，有多个属性
		# create 'testFeedback',{NAME=>'Leotest_HBase',VERSIONS=>1, BLOCKCACHE=>true,BLOOMFILTER=>'ROW',COMPRESSION=>'SNAPPY',TTL => 2592000 },{SPLITS => ['1','2','a','b']}

2-1 创建最大长度的名的表 25B
2-2 创建最大长度的名的列族 127B ,可以put且scan
2-3 创建特殊字符、中文的表名  : (&*_-中文
2-4 大小写的表名测试

3-1 创建已经存在的表
3-2 不支持的命令:同时创建多个表




