---
title: Hive安装
date: 2019-06-09 14:53:02
tags: [hive,hadoop,bigdata]
---
## Hive安装地址
```
1）Hive 官网地址：
http://hive.apache.org/
2）文档查看地址：
https://cwiki.apache.org/confluence/display/Hive/GettingStarted
3）下载地址：
http://hive.apache.org/downloads.html
https://mirrors.tuna.tsinghua.edu.cn/apache/hive/
4）github 地址：
https://github.com/apache/hive
```

## Hive安装部署
### Hive安装及配置
```
（1）把 apache-hive-1.2.1-bin.tar.gz 上传到 linux 的 /software 目录下
（2）解压 apache-hive-1.2.1-bin.tar.gz 到/opt/目录下面
[root@vm1 software]# pwd
/software
[root@vm1 software]# ll
total 413916
-rw-r--r--. 1 root root 232027212 Jun  9 12:35 apache-hive-2.3.5-bin.tar.gz
-rw-r--r--. 1 root root 191817140 Mar 29 20:35 jdk-8u201-linux-x64.tar.gz
[root@vm1 software]# tar -zxvf apache-hive-2.3.5-bin.tar.gz -C /opt/

（3）修改 apache-hive-2.3.5-bin 的名称为 hive
[root@vm1 opt]# pwd
/opt
[root@vm1 opt]# ll
total 0
drwxr-xr-x. 10 root root 184 Jun  9 15:00 apache-hive-2.3.5-bin
drwxr-xr-x. 11 1000 1001 172 Apr  2 19:08 hadoop-3.1.1
drwxr-xr-x.  7   10  143 245 Dec 16 03:48 jdk1.8.0_201
[root@vm1 opt]# mv apache-hive-2.3.5-bin/ hive

（4）修改/opt/hive/conf 目录下的 hive-env.sh.template 名称为 hive-env.sh
[root@vm1 conf]# pwd
/opt/hive/conf
[root@vm1 conf]# mv hive-env.sh.template hive-env.sh

（5）配置 hive-env.sh 文件, HADOOP_HOME 路径,配置 HIVE_CONF_DIR 路径
HADOOP_HOME=/opt/hadoop-3.1.1
HIVE_CONF_DIR=/opt/hive/conf
```

### Hadoop集群配置
```
（1）必须启动 hdfs 和 yarn
[root@vm1 hadoop-3.1.1]# sbin/start-dfs.sh
[root@vm2 hadoop-3.1.1]# sbin/start-yarn.sh

（2）在 HDFS 上创建/tmp 和/user/hive/warehouse 两个目录并修改他们的同组权限可写
[root@vm1 hadoop-3.1.1]# bin/hadoop fs -mkdir /tmp
[root@vm1 hadoop-3.1.1]# bin/hadoop fs -mkdir -p /user/hive/warehouse
[root@vm1 hadoop-3.1.1]# hadoop fs -ls /
Found 7 items
drwxr-xr-x   - root supergroup          0 2019-06-04 19:40 /0906
-rw-r--r--   3 root supergroup         20 2019-06-04 07:12 /hello1.txt
-rw-r--r--   3 root supergroup         20 2019-06-04 07:13 /hello2.txt
drwxr-xr-x   - root supergroup          0 2019-06-09 15:16 /tmp
drwxr-xr-x   - root supergroup          0 2019-06-09 15:17 /user
[root@vm1 hadoop-3.1.1]#

[root@vm1 hadoop-3.1.1]# bin/hadoop fs -chmod 777 /tmp
[root@vm1 hadoop-3.1.1]# bin/hadoop fs -chmod 777 /user/hive/warehouse
[root@vm1 hadoop-3.1.1]# hadoop fs -ls /
Found 7 items
drwxr-xr-x   - root supergroup          0 2019-06-04 19:40 /0906
-rw-r--r--   3 root supergroup         20 2019-06-04 07:12 /hello1.txt
-rw-r--r--   3 root supergroup         20 2019-06-04 07:13 /hello2.txt
-rw-r--r--   3 root supergroup         20 2019-06-04 19:44 /hello4.txt
-rw-r--r--   3 root supergroup         20 2019-06-04 07:04 /hello6.txt
drwxrwxrwx   - root supergroup          0 2019-06-09 15:16 /tmp
drwxr-xr-x   - root supergroup          0 2019-06-09 15:17 /user
[root@vm1 hadoop-3.1.1]# hadoop fs -ls /user/hive/
Found 1 items
drwxrwxrwx   - root supergroup          0 2019-06-09 15:17 /user/hive/warehouse
[root@vm1 hadoop-3.1.1]#

```

### Hive基本操作
```
（1）启动 hive
[root@vm1 hive]# pwd
/opt/hive
[root@vm1 hive]# bin/hive
（2）查看数据库
hive>show databases;
（3）打开默认数据库
hive>use default;
（4）显示 default 数据库中的表
hive>show tables;
（5）创建一张表
hive> create table student(id int, name string);
（6）显示数据库中有几张表
hive>show tables;
（7）查看表的结构
hive>desc student;
（8）向表中插入数据
hive> insert into student values(1000,"ss");
（9）查询表中数据
hive> select * from student;
（10）退出 hive
hive> quit;
```

## Hive操作
### 配置Metastore到MySql
根据官方文档配置参数，拷贝数据到 hive-site.xml 文件中
配置在 /opt/hive/conf 目录下。

```xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
	<property>
		<name>hive.metastore.local</name>
		<value>false</value>
		<description>controls whether to connect to remove metastore server or open a new metastore server in Hive Client JVM</description>
	</property>
	<!--连接数据库地址，名称 -->
	<property>
		<name>javax.jdo.option.ConnectionURL</name>
		<value>jdbc:mysql://192.168.192.8:3306/metastore?createDatabaseIfNotExist=true&amp;useUnicode=true&amp;characterEncoding=utf8&amp;iuseSSL=false</value>
		<description>JDBC connect string for a JDBC metastore</description>
	</property>
	<!--连接数据库驱动 -->
	<property>
		<name>javax.jdo.option.ConnectionDriverName</name>
		<value>com.mysql.jdbc.Driver</value>
		<description>Driver class name for a JDBC metastore</description>
	</property>
	<!--连接数据库用户名称 -->
	<property>
		<name>javax.jdo.option.ConnectionUserName</name>
		<value>root</value>
		<description>username to use against metastore database</description>
	</property>
	<!--连接数据库用户密码 -->
	<property>
		<name>javax.jdo.option.ConnectionPassword</name>
		<value>123456</value>
		<description>password to use against metastore database</description>
	</property>
	<!--客户端显示当前数据库名称信息 --> 
	<property>
		<name>hive.cli.print.current.db</name>
		<value>true</value>
		<description>Whether to include the current database in the Hive prompt.</description>
	</property>
	<!--客户端显示当前查询表的头信息 -->
	<property>
		<name>hive.cli.print.header</name>
		<value>false</value>
		<description>Whether to print the names of the columns in query output.</description>
	</property>
</configuration>
```
### 上传mysql驱动
上传mysql驱动(mysql-connector-java-5.1.45.jar), 在 /opt/hive/lib 目录下。

### 启动Hive出现错误
```bash
[root@vm1 hive]# bin/hive
which: no hbase in (/opt/jdk1.8.0_201/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/jdk1.8.0_201/bin:/opt/hadoop-3.1.1/bin:/opt/hadoop-3.1.1/sbin:/root/bin)
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/opt/hive/lib/log4j-slf4j-impl-2.6.2.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/opt/hadoop-3.1.1/share/hadoop/common/lib/slf4j-log4j12-1.7.25.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]

Logging initialized using configuration in jar:file:/opt/hive/lib/hive-common-2.3.5.jar!/hive-log4j2.properties Async: true
Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
hive> show databases;
FAILED: SemanticException org.apache.hadoop.hive.ql.metadata.HiveException: java.lang.RuntimeException: Unable to instantiate org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient
hive>
```
### 初始化数据库
出现上面的错误，是因为没有初始化数据库。
从Hive 2.1开始，我们需要运行下面的schematool命令作为初始化步骤。例如，这里使用“mysql”作为db类型

```bash
[root@vm1 hive]# cd bin
[root@vm1 bin]# schematool -dbType mysql -initSchema
-bash: schematool: command not found
[root@vm1 bin]# yum -y install schematool
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.nju.edu.cn
 * extras: ftp.sjtu.edu.cn
 * updates: mirrors.163.com
base                                                                                                                               | 3.6 kB  00:00:00     
extras                                                                                                                             | 3.4 kB  00:00:00     
updates                                                                                                                            | 3.4 kB  00:00:00     
No package schematool available.
Error: Nothing to do
[root@vm1 bin]#
[root@vm1 bin]# ./schematool -dbType mysql -initSchema
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/opt/hive/lib/log4j-slf4j-impl-2.6.2.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/opt/hadoop-3.1.1/share/hadoop/common/lib/slf4j-log4j12-1.7.25.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]
Metastore connection URL:	 jdbc:mysql://122.112.227.174:3306/metastore?createDatabaseIfNotExist=true&useUnicode=true&characterEncoding=utf8&iuseSSL=false
Metastore Connection Driver :	 com.mysql.jdbc.Driver
Metastore connection User:	 root
Mon Jun 10 16:24:03 CST 2019 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
Starting metastore schema initialization to 2.3.0
Initialization script hive-schema-2.3.0.mysql.sql
Mon Jun 10 16:24:04 CST 2019 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
Initialization script completed
Mon Jun 10 16:24:11 CST 2019 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
schemaTool completed
[root@vm1 bin]#
```

### 测试Hive
```bash
[root@vm1 hive]# bin/hive
which: no hbase in (/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/jdk1.8.0_201/bin:/opt/hadoop-3.1.1/bin:/opt/hadoop-3.1.1/sbin:/root/bin)
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/opt/hive/lib/log4j-slf4j-impl-2.6.2.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/opt/hadoop-3.1.1/share/hadoop/common/lib/slf4j-log4j12-1.7.25.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]

Logging initialized using configuration in jar:file:/opt/hive/lib/hive-common-2.3.5.jar!/hive-log4j2.properties Async: true
Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
hive (default)> show databases;
Mon Jun 10 16:27:01 CST 2019 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
Mon Jun 10 16:27:02 CST 2019 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
Mon Jun 10 16:27:03 CST 2019 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
Mon Jun 10 16:27:03 CST 2019 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
Mon Jun 10 16:27:05 CST 2019 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
Mon Jun 10 16:27:06 CST 2019 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
Mon Jun 10 16:27:06 CST 2019 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
Mon Jun 10 16:27:06 CST 2019 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
OK
default
Time taken: 12.227 seconds, Fetched: 1 row(s)
hive (default)>
```

### Hive创建表
```bash
hive (default)> use default;
OK
Time taken: 0.368 seconds
hive (default)> show tables;
OK
Time taken: 0.295 seconds
hive (default)> create table student(id int, name string);
OK
Time taken: 2.043 seconds
hive (default)> show tables;
OK
student
Time taken: 0.376 seconds, Fetched: 1 row(s)
hive (default)> desc student;
OK
id                  	int                 	                    
name                	string              	                    
Time taken: 0.627 seconds, Fetched: 2 row(s)
hive (default)> insert into student values(1000,"ss");
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = root_20190610163226_7e5140d5-705e-424b-b7e6-4678b6038e43
Total jobs = 3
Launching Job 1 out of 3
Number of reduce tasks is set to 0 since there's no reduce operator
Starting Job = job_1560152352405_0001, Tracking URL = http://vm2:8088/proxy/application_1560152352405_0001/
Kill Command = /opt/hadoop-3.1.1/bin/hadoop job  -kill job_1560152352405_0001
Hadoop job information for Stage-1: number of mappers: 0; number of reducers: 0
2019-06-10 16:32:46,463 Stage-1 map = 0%,  reduce = 0%
Ended Job = job_1560152352405_0001 with errors
Error during job, obtaining debugging information...
FAILED: Execution Error, return code 2 from org.apache.hadoop.hive.ql.exec.mr.MapRedTask
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 0 HDFS Write: 0 FAIL
Total MapReduce CPU Time Spent: 0 msec
hive (default)> 
```

新建表：

![Hive安装](/assets/images/bigdata/hive安装_新建表001.png)

### Hive中运行任务报错
```
Ended Job = job_1560152352405_0001 with errors
Error during job, obtaining debugging information...
FAILED: Execution Error, return code 2 from org.apache.hadoop.hive.ql.exec.mr.MapRedTask
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 0 HDFS Write: 0 FAIL
Total MapReduce CPU Time Spent: 0 msec
```

#### 失败原因
```
经查发现发现/tmp/hadoop/.log提示java.lang.OutOfMemoryError: Java heap space，原因是namenode内存空间不够，jvm不够新job启动导致。
```

#### 解决方法
```
将你的hive可以设置成本地模式来执行任务试试：
hive (default)> set hive.exec.mode.local.auto=true;
```

#### 再次插入数据
```bash
hive (default)> insert into student values(1000,"ss");
Automatically selecting local only mode for query
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = root_20190611142952_63ed50fe-bdde-43d2-b4cb-f4827ab25e75
Total jobs = 3
Launching Job 1 out of 3
Number of reduce tasks is set to 0 since there's no reduce operator
Job running in-process (local Hadoop)
2019-06-11 14:29:55,623 Stage-1 map = 100%,  reduce = 0%
Ended Job = job_local997893747_0001
Stage-4 is selected by condition resolver.
Stage-3 is filtered out by condition resolver.
Stage-5 is filtered out by condition resolver.
Moving data to directory hdfs://vm1:9000/user/hive/warehouse/student/.hive-staging_hive_2019-06-11_14-29-52_444_84437470798176415-1/-ext-10000
Loading data to table default.student
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 8 HDFS Write: 34636713 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
Time taken: 7.701 seconds
hive (default)> select * from student;
OK
1000	ss
Time taken: 0.744 seconds, Fetched: 1 row(s)
hive (default)>
```

在表中插入数据：

![Hive安装](/assets/images/bigdata/hive安装_新建表002.png)

### 将本地文件导入Hive
需求：将本地/opt/datas/student.txt 这个目录下的数据导入到 hive 的 student(id int, name string)表中。

#### 数据准备
在/opt/datas/student.txt 这个目录下准备数据，
[root@vm1 datas]# vim student.txt
1001	zhangshan
1002	lishi
1003	zhaoliu
注意以 tab 键间隔(否则查询出来会出现NULL)
#### 删除已创建的student表,并重新建表

删除已创建的student表
drop table student;

创建student表, 并声明文件分隔符'\t'
create table student(id int, name string) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

加载/opt/datas/student.txt 文件到 student 数据库表中
load data local inpath '/opt/datas/student.txt' into table student;

```bash
hive (default)> drop table student;
hive (default)> create table student(id int, name string) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
OK
Time taken: 1.394 seconds
hive (default)> show tables;
OK
student
values__tmp__table__1
values__tmp__table__2
values__tmp__table__3
Time taken: 0.361 seconds, Fetched: 4 row(s)
hive (default)> load data local inpath '/opt/datas/student.txt' into table student;
Loading data to table default.student
OK
Time taken: 5.247 seconds
hive (default)>
hive (default)> truncate table student;
OK
Time taken: 1.727 seconds
hive (default)> select * from student;
OK
Time taken: 0.891 seconds
hive (default)> load data local inpath '/opt/datas/student.txt' into table student;
Loading data to table default.student
OK
Time taken: 6.231 seconds
hive (default)> select * from student;
OK
1011	zhangshan
1012	lishi
1013	zhaoliu
Time taken: 0.905 seconds, Fetched: 3 row(s)
hive (default)>
```