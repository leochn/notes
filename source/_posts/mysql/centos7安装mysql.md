---
title: centos7安装mysql
date: 2017-07-30 06:08:39
tags: [mysql,centos7]
---
本文是 CentOS7下使用yum安装MySQL的一些步骤
<!-- more -->
## 查看mysql的安装路径
```
[root@ ~]# whereis mysql
mysql: /usr/lib64/mysql /usr/share/mysql
```

## 查看mysql的安装包
```
[root@ ~]# rpm -qa|grep mysql
[root@ ~]#
```

## 安装mysql
### 从oracle官方网站下载linux系统对应的mysql的yum源包
```
https://dev.mysql.com/downloads/repo/yum/
mysql57-community-release-el7-11.noarch

```

### 把yum源包上传到linux
```
[root@ mysql]# cd /usr/local/src/mysql/
[root@ mysql]# ll
总用量 28
-rw-r--r--. 1 root root 25680 7月  29 20:03 mysql57-community-release-el7-11.noarch.rpm
```

### 安装
```
[root@ mysql]# yum localinstall mysql57-community-release-el7-11.noarch.rpm
[root@ mysql]# yum install mysql-server
```

### 启动mysqld服务
[root@ mysql]# systemctl status mysqld

### yum 安装mysql后,无法通过空密码登录数据库
```
[root@ log]# mysql -u root -p                   
Enter password: 
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)
[root@ log]#
```

### 查看安装后的临时密码

此时mysql5.7会为root随机生成一个密码在/var/log/mysqld.log 日志文件中

输入命令：
grep "password" /var/log/mysqld.log 

密码就在这个日志的文件里
/var/log/mysqld.log 

例如：标注的就是密码
2017-07-29T12:49:54.866987Z 1 [Note] A temporary password is generated for root@localhost: fXU8:5t=NhyD

### 使用临时密码登录数据库
```
[root@ log]# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 7
Server version: 5.7.19

Copyright (c) 2000, 2017, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```

### 提示修改密码
```
mysql> show databases;
ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.
```

### 提示密码太简单,密码需要大写字母,小写字母和特殊字符
```
mysql>  SET PASSWORD = PASSWORD('root');
ERROR 1819 (HY000): Your password does not satisfy the current policy requirements
mysql> SET PASSWORD = '123QWEasd!@#';
Query OK, 0 rows affected (0.00 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)

mysql> 
```

## 远程连接授权
GRANT ALL PRIVILEGES ON *.* TO 'myuser'@'%' IDENTIFIED BY 'mypassword' WITH GRANT OPTION;
注意：'myuser'、'mypassword' 需要替换成实际的用户名和密码

```
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123QWEasd!@#' WITH GRANT OPTION;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql>
```

### 开发3306端口
```
[root@ log]# firewall-cmd --zone=public --add-port=3306/tcp --permanent  
success
[root@ log]# firewall-cmd --reload
success
[root@ log]#
```

## linux下MySQL表名不区分大小写的设置方法

原来Linux下的MySQL默认是区分表名大小写的，通过如下设置，可以让MySQL不区分表名大小写：

1、用root登录，修改 /etc/my.cnf；
2、在[mysqld]节点下，加入一行： lower_case_table_names=1
3、重启MySQL即可；
其中 lower_case_table_names=1 参数缺省地在 Windows 中这个选项为 1 ，
在 Unix 中为 0，因此在window中不会遇到的问题，一旦一直到linux就会出问题的原因.

























