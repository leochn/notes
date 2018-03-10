---
title: mysql数据库优化06
date: 2018-03-08 13:30:10
tags:
---
## 三表索引优化
<!-- more -->
```sql
CREATE TABLE `phone` (
  `phoneid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `card` int(10) NOT NULL,
  PRIMARY KEY (`phoneid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES (FLOOR(1+(RAND()*20)));
```

## 查看表中的索引
```sql
mysql> SHOW INDEX FROM book;
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| book  |          0 | PRIMARY  |            1 | bookid      | A         |          20 |     NULL | NULL   |      | BTREE      |         |               |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
1 row in set (0.00 sec)

mysql> SHOW INDEX FROM class;
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| class |          0 | PRIMARY  |            1 | id          | A         |          20 |     NULL | NULL   |      | BTREE      |         |               |
| class |          1 | Y        |            1 | card        | A         |          15 |     NULL | NULL   |      | BTREE      |         |               |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
2 rows in set (0.00 sec)

mysql> drop index Y on class;
Query OK, 0 rows affected (0.22 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql>
```

## EXPLAIN
```sql
mysql> EXPLAIN SELECT * FROM class INNER JOIN book ON class.card = book.card INNER JOIN phone ON book.card = phone.card;
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                                              |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
|  1 | SIMPLE      | class | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   20 |   100.00 | NULL                                               |
|  1 | SIMPLE      | book  | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   20 |    10.00 | Using where; Using join buffer (Block Nested Loop) |
|  1 | SIMPLE      | phone | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   20 |    10.00 | Using where; Using join buffer (Block Nested Loop) |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
3 rows in set, 1 warning (0.00 sec)

mysql>
```

## Extra：包含不适合在其他列中显示但十分重要的额外信息
### Using filesort

### Using temporary

### Using index

### Using where

### Using join buffer：使用了连接缓存

### impossible where

### select tables optimized away +

### distinct +

## EXPLAIN
```sql
mysql> EXPLAIN SELECT * FROM class LEFT JOIN book ON class.card = book.card LEFT JOIN phone ON book.card = phone.card;
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                                              |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
|  1 | SIMPLE      | class | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   20 |   100.00 | NULL                                               |
|  1 | SIMPLE      | book  | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   20 |   100.00 | Using where; Using join buffer (Block Nested Loop) |
|  1 | SIMPLE      | phone | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   20 |   100.00 | Using where; Using join buffer (Block Nested Loop) |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
3 rows in set, 1 warning (0.00 sec)

mysql>
```

## 优化索引
```sql
mysql> ALTER TABLE phone ADD INDEX Z (card);
Query OK, 0 rows affected (0.39 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE book ADD INDEX Y (card);
Query OK, 0 rows affected (0.28 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> EXPLAIN SELECT * FROM class LEFT JOIN book ON class.card = book.card LEFT JOIN phone ON book.card = phone.card;
+----+-------------+-------+------------+------+---------------+------+---------+--------------------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref                | rows | filtered | Extra       |
+----+-------------+-------+------------+------+---------------+------+---------+--------------------+------+----------+-------------+
|  1 | SIMPLE      | class | NULL       | ALL  | NULL          | NULL | NULL    | NULL               |   20 |   100.00 | NULL        |
|  1 | SIMPLE      | book  | NULL       | ref  | Y             | Y    | 4       | mybatis.class.card |    2 |   100.00 | Using index |
|  1 | SIMPLE      | phone | NULL       | ref  | Z             | Z    | 4       | mybatis.book.card  |    1 |   100.00 | Using index |
+----+-------------+-------+------------+------+---------------+------+---------+--------------------+------+----------+-------------+
3 rows in set, 1 warning (0.00 sec)

mysql>
```

### 结论
1.最后2行的type 都是 ref 且 rows 优化很好，效果不错。因此索引最好设置在需要经常查询的字段中。

2.尽可能减少Join语句中的 NestedLoop 的循环总次数，永远用小结果集驱动大的结果集。

3.优先优化 NestedLoop 的内循环。

4.保证join 语句中被驱动的表上join 条件字段被索引。

5.当无法保证被驱动表的join条件字段被索引且内存资源充足的前提下，不要太吝啬JoinBuffer的设置。






