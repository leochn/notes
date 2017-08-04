---
title: linux-01一些命令
date: 2017-07-22 06:43:22
tags: linux
---
## 没有netstat命令
``-bash: netstat: command not found``

运行  ```yum install net-tools```  就OK了

## centos查看文件大小(ll -h)

```
[root@wpg-ja-dbs01 ~]# ll
total 8
drwxr-xr-x 2 root root 4096 Jul  7 09:16 jdk
drwxr-xr-x 2 root root 4096 Jul  7 16:05 mycat
[root@wpg-ja-dbs01 ~]# ll -h
total 8.0K
drwxr-xr-x 2 root root 4.0K Jul  7 09:16 jdk
drwxr-xr-x 2 root root 4.0K Jul  7 16:05 mycat
[root@wpg-ja-dbs01 ~]#
```
