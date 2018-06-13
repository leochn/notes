---
title: 查看mysql数据库连接数-并发数相关信息
date: 2018-06-13 12:50:51
tags: mysql
---
## 查看mysql数据库连接数 
```
mysql> show status like 'Threads%';
+-------------------+-------+
| Variable_name     | Value |
+-------------------+-------+
| Threads_cached    | 58    |
| Threads_connected | 57    |   ###这个数值指的是打开的连接数
| Threads_created   | 3676  |
| Threads_running   | 4     |   ###这个数值指的是激活的连接数，这个数值一般远低于connected数值
+-------------------+-------+
 
Threads_connected 跟show processlist结果相同，表示当前连接数。准确的来说，Threads_running是代表当前并发数
```
<!-- more -->

## 当前设置的最大连接数
```
mysql> show variables like '%max_connections%';
+-----------------+-------+
| Variable_name   | Value |
+-----------------+-------+
| max_connections | 1000  |
+-----------------+-------+
 
可以在/etc/my.cnf里面设置数据库的最大连接数
[mysqld]
max_connections = 1000

max_connections 参数可以用于控制数据库的最大连接数
```

## 连接数
```
mysql> show variables like '%connect%';
+--------------------------+-------------------+
| Variable_name            | Value             |
+--------------------------+-------------------+
| character_set_connection | latin1            | 
| collation_connection     | latin1_swedish_ci | 
| connect_timeout          | 10                | 
| init_connect             |                   | 
| max_connect_errors       | 10                | 
| max_connections          | 4000              | 
| max_user_connections     | 0                 | 
+--------------------------+-------------------+

很多开发人员都会遇见”MySQL: ERROR 1040: Too many connections”的异常情况，造成这种情况的一种原因是访问量过高，MySQL服务器抗不住，这个时候就要考虑增加从服务器分散读压力；另一种原因就是MySQL配置文件中max_connections值过小。
```

## 查看mysql的最大连接数
```
mysql> show variables like '%max_connections%';
+-----------------+-------+
| Variable_name  | Value |
+-----------------+-------+
| max_connections | 151  |
+-----------------+-------+
1 row in set (0.00 sec)
```

## 查看服务器响应的最大连接数
```
mysql> show global status like 'Max_used_connections';
+----------------------+-------+
| Variable_name    | Value |
+----------------------+-------+
| Max_used_connections | 2   |
+----------------------+-------+
1 row in set (0.00 sec)
```

可以看到服务器响应的最大连接数为2，远远低于mysql服务器允许的最大连接数值。

对于mysql服务器最大连接数值的设置范围比较理想的是：服务器响应的最大连接数值占服务器上限连接数值的比例值在10%以上，如果在10%以下，说明mysql服务器最大连接上限值设置过高。

```
Max_used_connections / max_connections * 100% = 2/151 *100% ≈ 1%
```

我们可以看到占比远低于10%（因为这是本地测试服务器，结果值没有太大的参考意义，大家可以根据实际情况设置连接数的上限值）。

## 如何设置这个最大连接数值
### 方法1
```
mysql> set GLOBAL max_connections=256;
Query OK, 0 rows affected (0.00 sec)
mysql> show variables like '%max_connections%';
+-----------------+-------+
| Variable_name  | Value |
+-----------------+-------+
| max_connections | 256  |
+-----------------+-------+
1 row in set (0.00 sec)
```

### 方法2
```
修改mysql配置文件my.cnf，在[mysqld]段中添加或修改max_connections值：
max_connections=128
重启mysql服务即可
```