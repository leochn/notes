---
title: mysql数据库优化08
date: 2018-03-11 18:40:12
tags: mysql
---
## 数据库锁的分类(对数据库操作的类型)

读锁(共享锁)：针对同一份数据，多个读操作可以同时进行而不会互相影响。

写锁(排他锁)：当前写操作没有完成前，它会阻断其他写锁和读锁。
<!-- more -->

## 三锁

### 表锁(偏读)
#### 特点
偏向MyISAM存储引擎，开销小，加锁快；无死锁；锁定粒度大，发生锁冲突的概率最高，并发度最低。

#### 案例分析
```sql
CREATE TABLE `mylock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO mylock(name) VALUES('a');
INSERT INTO mylock(name) VALUES('b');
INSERT INTO mylock(name) VALUES('c');
INSERT INTO mylock(name) VALUES('d');
INSERT INTO mylock(name) VALUES('e');
INSERT INTO mylock(name) VALUES('f');
-- 查看表上加过的锁
SHOW OPEN tables;
-- 手动增加表锁
LOCK TABLE mylock READ,book WRITE;
-- 手动释放锁
UNLOCK TABLES;
```

```sql
mysql> SHOW OPEN tables;
+--------------------+------------------------------------------------------+--------+-------------+
| Database           | Table                                                | In_use | Name_locked |
+--------------------+------------------------------------------------------+--------+-------------+
| performance_schema | events_waits_summary_by_user_by_event_name           |      0 |           0 |
| mysql              | help_topic                                           |      0 |           0 |
| mybatis            | mylock                                               |      0 |           0 |
| mybatis            | book                                                 |      0 |           0 |
| mybatis            | student                                              |      0 |           0 |
+--------------------+------------------------------------------------------+--------+-------------+

mysql> LOCK TABLE mylock READ,book WRITE;

mysql> SHOW OPEN tables;
+--------------------+------------------------------------------------------+--------+-------------+
| Database           | Table                                                | In_use | Name_locked |
+--------------------+------------------------------------------------------+--------+-------------+
| performance_schema | events_waits_summary_by_user_by_event_name           |      0 |           0 |
| mysql              | help_topic                                           |      0 |           0 |
| mybatis            | mylock                                               |      1 |           0 |
| mybatis            | book                                                 |      1 |           0 |
| mybatis            | student                                              |      0 |           0 |
+--------------------+------------------------------------------------------+--------+-------------+

mysql> UNLOCK TABLES;
Query OK, 0 rows affected (0.00 sec)

mysql> SHOW OPEN tables;
+--------------------+------------------------------------------------------+--------+-------------+
| Database           | Table                                                | In_use | Name_locked |
+--------------------+------------------------------------------------------+--------+-------------+
| performance_schema | events_waits_summary_by_user_by_event_name           |      0 |           0 |
| mysql              | help_topic                                           |      0 |           0 |
| mybatis            | mylock                                               |      0 |           0 |
| mybatis            | book                                                 |      0 |           0 |
| mybatis            | student                                              |      0 |           0 |
+--------------------+------------------------------------------------------+--------+-------------+
```

#### (读锁案例)session1给mylock表加read锁

![mysql共享锁](/assets/images/mysql/mysql共享锁001.png)
![mysql共享锁](/assets/images/mysql/mysql共享锁002.png)
![mysql共享锁](/assets/images/mysql/mysql共享锁003.png)
![mysql共享锁](/assets/images/mysql/mysql共享锁004.png)
![mysql共享锁](/assets/images/mysql/mysql共享锁005.png)

```
0.mylock表,被session1加read锁后.
1.session1 能读mylock表.
2.session1 不能修改mylock表.
3.session1 不能读其他的表.
4.session2 能读任何表,包括被session1加锁的mylock表.
5.mylock表,被session1加锁后，session2 不能修改mylock表,处于阻塞状态(会一直等待获得锁).
5.mylock表,被session1解锁后，session2 获得锁,对mylock表的插入操作完成.
```

#### (写锁案例)
```
1.session1给mylock表加write锁后.
2.session1, 能读mylock表,能修改mylock表,不能读其他的表.
2.session2, 能读其他表,不能读mylock表.
```

![mysql共享锁](/assets/images/mysql/mysql共享锁006.png)
![mysql共享锁](/assets/images/mysql/mysql共享锁007.png)

#### 结论
1.MyISAM在执行查询语句(select)前，会自动给涉及的所有表加读锁，在执行增删改操作前，会自动给涉及的表加写锁。

2.对MyISAM表的读操作(加读锁)，不会阻塞其他进程对同一表的读请求，但会阻塞对 同一表的写请求。只有当读锁释放后，才会执行其他进程的写操作。

3.对MyISAM表的写操作(加写锁)，会阻塞其他进程对同一表的读和写操作，只有当写锁释放后，才会执行其他进程的读写操作。

4.简而言之，就是读锁会阻塞写，但是不会阻塞读。而写锁会把读和写都阻塞。

#### 如何分析表锁定
```
可以通过 show status like 'table%'; 语句查询.

这里有两个状态变量记录mysql内部表级锁定的情况：
Table_locks_immediate:产生表级锁定的次数，表示可以立即获取锁的查询次数，每立即获取锁值加1.

Table_locks_waited:出现表级锁定争用，而发生等待的次数(不能立即获取锁的次数，每等待一次锁值加1)，此值高说明存在着较严重的表级锁争用情况。

MyISAM的读写锁调度是写优先，着也是MyISAM不适合做写为主表的引擎。因为写锁后，其他线程不能做任何操作，大量的更新会使查询很难得到哦锁，从而造成永远阻塞。
```

### 行锁(偏写)
#### 特点
偏向InnoDB存储引擎，开销大，加锁慢；会出现死锁；锁定粒度最小，发生锁冲突的概率最低，并发度最高。

InnoDB 与 MyISAM 两个最大的不同点:支持事务；采用了行级锁.

并发事务处理带来的问题：
1.更新丢失：
当两个或多个事务选择同一行，然后基于最初选定的值更新改行时，由于每个事务都不知道其他事务的存在，就会发生丢失更新的问题，最后的更新覆盖了由其他事务所做的更新。

如果一个事务完成并提交之前，另一个事务不能访问该行，则可以避免此问题。

2.胀读：事务A 读取到了事务B 已经修改但尚未提交的数据，还在这个数据基础上做了操作。此时，如果事务B回滚，A读取的数据无效，不符合一致性的要求。

3.不可重复读：
一个事务在读取某些数据后的某个时间，再次读取以前读过的数据，却发现其读出的数据已经发生了改变、或某些记录已经被删除了。这种现象叫做"不可重复读".

一句话：事务A 读取到了事务B已经提交的修改数据，不符合隔离性。

4.幻读：
一个事务按相同的查询条件重新读取以前检索过的数据，却发现其他事务插入了满足其查询条件的新数据，这种现象就称为"幻读".

一句话：事务A读取到了事务B提交的新增数据，不符合隔离性。

幻读和胀读有点类似，胀读是事务B里面修改了数据，幻读是事务B里面新增了数据。

#### 案例分析
1.创建表

```sql
CREATE TABLE `test_innodb_lock` (
  `a` int(11) DEFAULT NULL,
  `b` varchar(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO test_innodb_lock VALUES(1,'a1');
INSERT INTO test_innodb_lock VALUES(3,'3');
INSERT INTO test_innodb_lock VALUES(4,'4000');
INSERT INTO test_innodb_lock VALUES(5,'5000');
INSERT INTO test_innodb_lock VALUES(6,'6000');
INSERT INTO test_innodb_lock VALUES(7,'7000');
INSERT INTO test_innodb_lock VALUES(8,'8000');
INSERT INTO test_innodb_lock VALUES(9,'9000');
INSERT INTO test_innodb_lock VALUES(1,'a2');

CREATE INDEX test_innodb_lock_a ON test_innodb_lock(a);
CREATE INDEX test_innodb_lock_b ON test_innodb_lock(b);
```

2.取消两个session自动提交 set autocommit=0;
![mysql共享锁](/assets/images/mysql/mysql共享锁006.png)

3.session1 修改 test_innodb_lock 表数据，没有提交，并查询数据(读己之所写,发现已经修改过来了)
```sql
mysql> update test_innodb_lock set b='4001' where a=4;
Query OK, 1 row affected (0.89 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> select * from test_innodb_lock;
+------+------+
| a    | b    |
+------+------+
|    1 | a1   |
|    3 | 3    |
|    4 | 4001 |
|    5 | 5000 |
|    6 | 6000 |
|    7 | 7000 |
|    8 | 8000 |
|    9 | 9000 |
|    1 | a2   |
+------+------+
9 rows in set (0.00 sec)

mysql>
```

4.session2 并查询数据(数据并没有修改过来)

### 页锁(介于表锁和行锁之间)




