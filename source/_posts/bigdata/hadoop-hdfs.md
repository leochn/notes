---
title: hadoop-hdfs
date: 2019-06-08 07:07:28
tags: [hadoop,bigdata]
---
## HDFS产生背景
​	随着数据量越来越大，在一个操作系统管辖的范围内存不下了，那么就分配到更多的操
作系统管理的磁盘中，但是不方便管理和维护，迫切需要一种系统来管理多台机器上的文件，
这就是分布式文件管理系统。HDFS 只是分布式文件管理系统中的一种。
<!-- more -->

## HDFS概念
​	HDFS，它是一个文件系统，用于存储文件，通过目录树来定位文件；其次，它是分布
式的，由很多服务器联合起来实现其功能，集群中的服务器有各自的角色。
​	HDFS 的设计适合一次写入，多次读出的场景，且不支持文件的修改。适合用来做数据
分析，并不适合用来做网盘应用。

## HDFS优缺点
### 优点
```
1）高容错性
（1）数据自动保存多个副本。它通过增加副本的形式，提高容错性。
（2）某一个副本丢失以后，它可以自动恢复。
2）适合大数据处理
（1）数据规模：能够处理数据规模达到 GB、TB、甚至 PB 级别的数据。
（2）文件规模：能够处理百万规模以上的文件数量，数量相当之大。
3）流式数据访问
（1）一次写入，多次读取，不能修改，只能追加。
（2）它能保证数据的一致性。
4）可构建在廉价机器上，通过多副本机制，提高可靠性。
```

### 缺点
```
1）不适合低延时数据访问，比如毫秒级的存储数据，是做不到的。
2）无法高效的对大量小文件进行存储
（1）存储大量小文件的话，它会占用 NameNode 大量的内存来存储文件、目录和块信
息。这样是不可取的，因为 NameNode 的内存总是有限的。
（2）小文件存储的寻址时间会超过读取时间，它违反了 HDFS 的设计目标。
3）并发写入、文件随机修改
（1）一个文件只能有一个写，不允许多个线程同时写。
（2）仅支持数据 append（追加），不支持文件的随机修改。
```
## HDFS架构

![HDFS架构](/assets/images/bigdata/hadoop-hdfs001.png)

这种架构主要由四个部分组成，分别为 HDFS Client、NameNode、DataNode 和 Secondary  

NameNode。下面我们分别介绍这四个组成部分。 

1）Client：就是客户端。 

（1）文件切分。文件上传 HDFS 的时候，Client 将文件切分成一个一个的 Block，然后进 

行存储。

（2）与 NameNode 交互，获取文件的位置信息。 

（3）与 DataNode 交互，读取或者写入数据。 

（4）Client 提供一些命令来管理 HDFS，比如启动或者关闭 HDFS。 

（5）Client 可以通过一些命令来访问 HDFS。 

2）NameNode：就是 master，它是一个主管、管理者。 

（1）管理 HDFS 的名称空间。 

（2）管理数据块（Block）映射信息 

（3）配置副本策略 

（4）处理客户端读写请求。 

3） DataNode：就是 Slave。NameNode 下达命令，DataNode 执行实际的操作。 

（1）存储实际的数据块。 

（2）执行数据块的读/写操作。 

4）Secondary NameNode：并非 NameNode 的热备。当 NameNode 挂掉的时候，它并不能马 

上替换 NameNode 并提供服务。 

（1）辅助 NameNode，分担其工作量。 

（2）定期合并 Fsimage 和 Edits，并推送给 NameNode。 

（3）在紧急情况下，可辅助恢复 NameNode。 

## HDFS 文件块大小
```
	HDFS 中的文件在物理上是分块存储（block），块的大小可以通过配置参数( dfs.blocksize) 
来规定，默认大小在 hadoop2.x 版本中是 128M，老版本中是 64M。 
	HDFS 的块比磁盘的块大，其目的是为了最小化寻址开销。如果块设置得足够大，从磁盘传输数据的时间会明显大于定位这个块开始位置所需的时间。因而，传输一个由多个块组成的文件的时间取决于磁盘传输速率。 
	如果寻址时间约为 10ms，而传输速率为 100MB/s，为了使寻址时间仅占传输时间的 1%， 
我们要将块大小设置约为 100MB。默认的块大小 128MB。 
	块的大小：10ms*100*100M/s = 100M
```

## HDFS客户端操作windows环境准备
### 解压hadoop-3.1.1

本文把hadoop解压在 /d/devlop/hadoop-3.1.1 目录下.
```
LEO@LAPTOP-GDA5CI61 MINGW64 /d/devlop/hadoop-3.1.1
$ pwd
/d/devlop/hadoop-3.1.1

LEO@LAPTOP-GDA5CI61 MINGW64 /d/devlop/hadoop-3.1.1
$ ll
total 184
drwxr-xr-x 1 LEO 197121      0 8月   2  2018 bin/
drwxr-xr-x 1 LEO 197121      0 8月   2  2018 etc/
drwxr-xr-x 1 LEO 197121      0 8月   2  2018 include/
drwxr-xr-x 1 LEO 197121      0 8月   2  2018 lib/
drwxr-xr-x 1 LEO 197121      0 8月   2  2018 libexec/
-rw-r--r-- 1 LEO 197121 147144 7月  29  2018 LICENSE.txt
-rw-r--r-- 1 LEO 197121  21867 7月  29  2018 NOTICE.txt
-rw-r--r-- 1 LEO 197121   1366 7月  29  2018 README.txt
drwxr-xr-x 1 LEO 197121      0 8月   2  2018 sbin/
drwxr-xr-x 1 LEO 197121      0 8月   2  2018 share/

```

### 添加Hadoop在win上需要的相关库文件，将其添加到hadoop的bin目录中

将windows需要的相关文件,拷贝到 /d/devlop/hadoop-3.1.1/bin 目录下。
```$xslt
LEO@LAPTOP-GDA5CI61 MINGW64 /d/workspace-leo/dev/hadoopBin
$ pwd
/d/workspace-leo/dev/hadoopBin

LEO@LAPTOP-GDA5CI61 MINGW64 /d/workspace-leo/dev/hadoopBin
$ ll
total 2872
-rwxr-xr-x 1 LEO 197121   94720 4月   7  2016 hadoop.dll*
-rw-r--r-- 1 LEO 197121   22061 4月   7  2016 hadoop.exp
-rw-r--r-- 1 LEO 197121   36988 4月   7  2016 hadoop.lib
-rw-r--r-- 1 LEO 197121  519168 4月   7  2016 hadoop.pdb
-rw-r--r-- 1 LEO 197121 1246366 4月   7  2016 libwinutils.lib
-rwxr-xr-x 1 LEO 197121  109568 4月   7  2016 winutils.exe*
-rw-r--r-- 1 LEO 197121  896000 4月   7  2016 winutils.pdb

```
### 配置hadoop的环境变量
```$xslt

HADOOP_HOME=D:\devlop\hadoop-3.1.1
并将HADOOP_HOME添加到path下。 %HADOOP_HOME%\bin
```

### 配置pom文件
```$xslt
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <hadoop.version>3.1.1</hadoop.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
        </dependency>
        <dependency>
            <groupId>org.apache.hadoop</groupId>
            <artifactId>hadoop-client</artifactId>
            <version>${hadoop.version}</version>
        </dependency>
        <dependency>
            <groupId>org.apache.hadoop</groupId>
            <artifactId>hadoop-common</artifactId>
            <version>${hadoop.version}</version>
        </dependency>
        <dependency>
            <groupId>org.apache.hadoop</groupId>
            <artifactId>hadoop-hdfs</artifactId>
            <version>${hadoop.version}</version>
        </dependency>
    </dependencies>
```