---
title: mysql去重
date: 2017-12-07 06:52:38
tags: mysql
---
## 使用场景
在使用mysql时，有时需要查询出某个字段不重复的记录.
<!-- more -->

## 测试数据:
```sql
CREATE TABLE `test_table` (
  `id` varchar(32) DEFAULT NULL,
  `uname` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `test_table` (`id`, `uname`) VALUES ('1', 'a');
INSERT INTO `test_table` (`id`, `uname`) VALUES ('2', 'b');
INSERT INTO `test_table` (`id`, `uname`) VALUES ('3', 'c');
INSERT INTO `test_table` (`id`, `uname`) VALUES ('4', 'c');
INSERT INTO `test_table` (`id`, `uname`) VALUES ('5', 'b');
```

## distinct
distinct 查询多表时，left join 还有效，全连接无效，
distinct只能返回它的目标字段，而无法返回其它字段.

```
测试1：
select distinct uname from test_table;
结果：
uname
a
b
c
好像达到效果了,但是只有一列有效。
```

```
测试2：
select distinct id,uname from test_table;
结果：
id  uname
1   a
2   b
3   c
4   c
5   b
distinct怎么没起作用？作用其实是起了，不过他同时作用了两个字段，也就是必须得id与name都相同的才会被排除。
```

## group by

```
测试：
select * from test_table group by uname;
结果：
id  uname
1   a
2   b
3   c
结果出来了，group by 必须放在 order by 和 limit之前，不然会报错。
```

