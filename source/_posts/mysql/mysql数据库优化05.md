---
title: mysql数据库优化05
date: 2018-03-08 13:30:02
tags: mysql
---
## mysql两表索引优化
<!-- more -->
```sql
CREATE TABLE `class` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `card` int(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `book` (
  `bookid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `card` int(10) NOT NULL,
  PRIMARY KEY (`bookid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO class(card) VALUES (FLOOR(1+(RAND()*20)));

INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
INSERT INTO book(card) VALUES (FLOOR(1+(RAND()*20)));
```

## EXPLAIN
```sql
mysql> EXPLAIN SELECT * FROM class LEFT JOIN book ON class.card = book.card;
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                                              |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
|  1 | SIMPLE      | class | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   20 |   100.00 | NULL                                               |
|  1 | SIMPLE      | book  | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   20 |   100.00 | Using where; Using join buffer (Block Nested Loop) |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
2 rows in set, 1 warning (0.00 sec)

mysql>
```

## 添加索引优化
```sql
mysql> ALTER TABLE book ADD INDEX Y(card);
Query OK, 0 rows affected (0.27 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> SHOW INDEX FROM book;
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| book  |          0 | PRIMARY  |            1 | bookid      | A         |          20 |     NULL | NULL   |      | BTREE      |         |               |
| book  |          1 | Y        |            1 | card        | A         |          10 |     NULL | NULL   |      | BTREE      |         |               |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
2 rows in set (0.00 sec)

mysql>
```
## EXPLAIN
```sql
mysql> EXPLAIN SELECT * FROM class LEFT JOIN book ON class.card = book.card;
+----+-------------+-------+------------+------+---------------+------+---------+--------------------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref                | rows | filtered | Extra       |
+----+-------------+-------+------------+------+---------------+------+---------+--------------------+------+----------+-------------+
|  1 | SIMPLE      | class | NULL       | ALL  | NULL          | NULL | NULL    | NULL               |   20 |   100.00 | NULL        |
|  1 | SIMPLE      | book  | NULL       | ref  | Y             | Y    | 4       | mybatis.class.card |    2 |   100.00 | Using index |
+----+-------------+-------+------------+------+---------------+------+---------+--------------------+------+----------+-------------+
2 rows in set, 1 warning (0.00 sec)

mysql>
```

结论：左连接把索引加在了右表上面

## 把索引加在左连接的左表上
```sql
mysql> drop index Y ON book;
Query OK, 0 rows affected (0.22 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE class ADD INDEX Y (card);
Query OK, 0 rows affected (0.30 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> SHOW INDEX FROM class;
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| class |          0 | PRIMARY  |            1 | id          | A         |          20 |     NULL | NULL   |      | BTREE      |         |               |
| class |          1 | Y        |            1 | card        | A         |          15 |     NULL | NULL   |      | BTREE      |         |               |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
2 rows in set (0.00 sec)

mysql> EXPLAIN SELECT * FROM class LEFT JOIN book ON class.card = book.card;
+----+-------------+-------+------------+-------+---------------+------+---------+------+------+----------+----------------------------------------------------+
| id | select_type | table | partitions | type  | possible_keys | key  | key_len | ref  | rows | filtered | Extra                                              |
+----+-------------+-------+------------+-------+---------------+------+---------+------+------+----------+----------------------------------------------------+
|  1 | SIMPLE      | class | NULL       | index | NULL          | Y    | 4       | NULL |   20 |   100.00 | Using index                                        |
|  1 | SIMPLE      | book  | NULL       | ALL   | NULL          | NULL | NULL    | NULL |   20 |   100.00 | Using where; Using join buffer (Block Nested Loop) |
+----+-------------+-------+------------+-------+---------------+------+---------+------+------+----------+----------------------------------------------------+
2 rows in set, 1 warning (0.00 sec)

mysql>
```

## 结论
LEFT JOIN 条件用于确定如何从右表搜索行，左边一定都有，所以右边是我们的关键点，一定要建立索引。



