#alter , alter_namespace

1-1 更改列族单元格的最大数目,并put
1-2 REPLICATION_SCOPE => 1
1-3 TTL => 2
1-4 删除 表范围运算符,MAX_FILESIZE
1-5 删除列族 { METHOD => 'delete',NAME => 'f1' }
1-6 一次执行多个 alter

2-1 增加修改属性 ，PROPERTY_NAME
2-2 删除属性 METHOD => 'unset'

3-1 修改不存在的表
3-2 修改存在的表，不存在的列族
3-3 修改不存在的namespace

