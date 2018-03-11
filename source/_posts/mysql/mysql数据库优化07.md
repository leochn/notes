---
title: mysql数据库优化07
date: 2018-03-11 18:39:46
tags:
---


```sql
CREATE TABLE `staffs` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) NOT NULL COMMENT '姓名',
  `age` int(10) NOT NULL DEFAULT '0' COMMENT '年龄',
  `pos` varchar(20) NOT NULL COMMENT '职位',
  `add_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '入职时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO staffs(name,age,pos,add_time) VALUES ('z3',22,'manager',NOW());
INSERT INTO staffs(name,age,pos,add_time) VALUES ('July',23,'dev',NOW());
INSERT INTO staffs(name,age,pos,add_time) VALUES ('z000',23,'dev',NOW());

ALTER TABLE staffs ADD INDEX idx_staffs_nameAgePos(name,age,pos);
```

## 索引失效的原因
### 1.全值匹配我最爱
```sql

```
### 2.最佳左前缀法则
### 3.不在索引列上做任何操作（计算，函数，自动or手动类型转换），会导致索引失效而转向全表扫描。
4.存储引擎不能使用索引中范围条件右边的列。
5.尽量使用覆盖索引（只访问索引的查询:索引列和查询列一致），减少select * 的操作。
6.mysql在使用不等于（!= 或者 <> ）的时候无法使用索引会导致全表扫描。
7.is null, is not null 也无法使用索引。
8.like以通配符开头('%abc...'),mysql索引失效会变成全表扫描的操作。
9.字符串不加单引号索引失效。
10.少用or,用它来连接是会索引失效。
