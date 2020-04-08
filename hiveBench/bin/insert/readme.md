##
#sql插入到表
1-1 insert into ,values 1次
1-2 insert overwrite 1次
1-3 insert into 2次
1-4 insert overwrite 2次
1-5 分区表 insert into ,2
1-6 桶表 insert into ,2 
1-7 分区表 insert overwrite  ,2
1-8 桶表 insert overwrite , 2

#插入到另一个表
2-1	insert into 到1个表 
2-2 insert overwrite 
2-3  into 2
2-4  overwrite 2
2-5 insert into 到 多个表

#2-6 insert into 到 分区表
#2-7 insert into 到 外部表
#2-8 insert into 到 桶型表
#2-9 insert into 到 临时表，临时表不在后数据全消失

##查询的数据insert到文件系统目录
3-1 insert到本地文件系统
3-2 inser到leofs文件系统
3-3 多次insert (2个文件系统 [分区表]
3-4 多次insert (2个文件系统 [桶型表]
3-5 insert到2个文件系统 local leofs
