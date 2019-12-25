## 说明
1-1		按照格式打印文件信息
1-2		按照格式打印文件夹信息

2-1		按照格式打印深层路径的文件
2-2		打印深层路径的文件夹

3-1		打印绝对路径
3-2		打印相对路径
3-3		打印本地文件信息

4-1		特殊字符，中文字符的文件信息

5-1		不存在的文件打印
5-2		错误指令的打印

Usage: hadoop fs [generic options] -stat [format] <path> ...
%b：打印文件大小（目录为0）
%n：打印文件名
%o：打印block size （我们要的值）
%r：打印备份数
%y：打印UTC日期 yyyy-MM-dd HH:mm:ss
%Y：打印自1970年1月1日以来的UTC微秒数
%F：目录打印directory, 文件打印regular file

 hadoop fs -stat "%b %n %o %r %y %Y %F" /api
