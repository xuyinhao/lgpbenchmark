 ## 简介
 对接Hadoop底层系统
 需要进行特性化的hadoop fs 接口的测试
 
 ### loongoopbench 
  就是hadoop fs命令行的测试 
  以及公司内部特有的特性进行测试的脚本
  
 ###  hbaseBench
  是关于hbase shell的基本测试
  以及 hbase MR,Tool的测试
    
 ### hiveBench
   关于hive ,beeline的语句测试
   
 ### global.conf
  统一全局的配置文件。
  每个Bench里面也可以单独的载写配置脚本（且会替换global的变量）
  
  
  
 
 
