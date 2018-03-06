---
title: mysql数据库优化03
date: 2018-03-07 07:21:00
tags: mysql
---

## mysql单表索引优化
<!-- more -->

```sql
CREATE TABLE `article` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `author_id` int(10) unsigned NOT NULL,
  `category_id` int(10) unsigned NOT NULL,
  `views` int(10) unsigned NOT NULL,
  `comments` int(10) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO article (
    author_id,
    category_id,
    views,
    comments,
    title,
    content
)
VALUES
    (1, 1, 1, 1, '1', '1'),
    (2, 2, 2, 2, '2', '2'),
    (1, 1, 3, 3, '3', '3')
```
要求：-- 查询category_id 为1 ，且comments 大于1 的情况下，views最多的article_id
第1次 EXPLAIN
```
mysql> EXPLAIN SELECT * from article WHERE category_id = 1 AND comments > 1 ORDER BY views DESC LIMIT 1;
+----+-------------+---------+------------+------+---------------+------+---------+------+------+----------+-----------------------------+
| id | select_type | table   | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                       |
+----+-------------+---------+------------+------+---------------+------+---------+------+------+----------+-----------------------------+
|  1 | SIMPLE      | article | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    3 |    33.33 | Using where; Using filesort |
+----+-------------+---------+------------+------+---------------+------+---------+------+------+----------+-----------------------------+
1 row in set, 1 warning (0.00 sec)
```

结论：很显然type是ALL ，即最坏的情况，Extra里面还出现了 Using filesort，也是最坏的情况，优化是必须的。

-- 第1次优化索引
-- 创建索引
CREATE INDEX idx_article_ccv on article(category_id,comments,views);

SHOW INDEX FROM article;

EXPLAIN SELECT * from article WHERE category_id = 1 AND comments > 1 ORDER BY views DESC LIMIT 1;
-- 结论：很显然type是 range ，即最坏的情况，Extra里面还出现了 Using filesort 。

EXPLAIN SELECT * from article WHERE category_id = 1 AND comments = 1 ORDER BY views DESC LIMIT 1;
-- ref 是2个常量 const,const

-- 结论：
-- type变成了range是可以忍受的，但是Extra里面还出现了 Using filesort，仍无法忍受。
-- 但是我们建立了索引，为什么还是没有起到效果呢？
-- 这是因为按照Btree索引的工作原理
-- 先排序 category_id
-- 如果遇到相同的category_id 则再排序comments，如果遇到相同的comments，则再排序views
-- 当comments字段在联合索引处于中间位置的时候，
-- 因为comment > 1 条件是一个范围值(所谓range)
-- mysql无法利用索引在对后面的views部分进行检索，即range类型查询字段后面的索引无效。 

-- 删除索引
DROP INDEX idx_article_ccv ON article;

-- 第2次优化索引
-- 创建索引
CREATE INDEX idx_article_cv on article(category_id,views);

SHOW INDEX FROM article;

EXPLAIN SELECT * from article WHERE category_id = 1 AND comments > 1 ORDER BY views DESC LIMIT 1;
-- 结论：
-- 可以看到type 变成了ref，Extra中的 Using filesort 也消失了，结果很理想。



