##说明
#find
##checkok 使用2>/dev/null
##checkerror  使用 2>&1
1-1		按照名字查找文件、文件夹
1-2		查找特殊字符，含有中文的文件，文件夹
1-3		查找长字符的文件 255

2-1		查找深层目录下的的一个文件,一个文件夹

3-1		查找本地file
3-2		查找leofs绝对路径 leofs:///
3-3		查找leofs相对路径 

4-1		使用-a连接查询
4-2		使用 print
4-3		使 print0
4-4		忽略大小写查询 -iname

5-1		查找不存在的目录
5-2		查找的文件返回为空
5-3		使用不存在的命令
5-4		使用错误的命令（少输入值）
