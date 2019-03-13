---
title: mysql数据库优化03
date: 2018-03-07 07:21:00
tags: mysql
---
## sql语句执行顺序
sql的执行顺序
<!-- more -->

### 手写
```sql
SELECT DISTINCT
    <select_list>
FROM 
    <left_table> <join_type>
JOIN <right_table> ON <join_condition>
WHERE
    <where_condition>
GROUP BY
    <group_by_list>
HAVING
    <having_condition>
ORDER BY
    <order_by_condition>
LIMIT <limit_number>
```

### 机器读
```sql
FROM <left_table>
ON <join_conditon>
<join_type> JOIN <right_table>
WHERE <where_condition>
GROUP BY <group_by_list>
HAVING <having_conditon>
SELECT
DISTINCT <select_list>
ORDER BY <order_by_condition>
LIMIT <limit_number>
```

## 索引是什么
在数据之外，数据库系统还维护着满足特定查找算法的数据结构，这些数据结构以某种方式引用（指向）数据，这样就可以在这些数据结构上实现高级查找算法。这种数据结构就是索引。

## 索引优劣势
优势：
1.提高数据检索的效率，降低了数据库的IO成本。
2.通过索引列对数据进行排序，降低数据排序的成本，降低了CPU的消耗。

劣势：
1.实际上索引也是一张表，该表保存了主键与索引字段，并指向实体表的记录，所以索引列也是要占用空间的。
2.虽然索引大大提高了查询速度，同时却会降低更新表的速度，如对表进行insert，update，delete。
3.因为更新表时，MySQL不仅要保存数据，还要保存一下索引文件每次更新添加了索引列的字段，都会调整因为更新数据带来的键值变化后的索引信息。
4.索引只是提高效率的一个因素，如果你的MySQL有大数据量的表，就需要花时间研究建立最优秀的索引，或优化查询语句。

## 索引分类和建索引命令语句
### 单值索引
即一个索引只包含单个列，一个表可以有多个单列索引。
一张表索引最多不要超过5个。
### 唯一索引
索引列的值必须唯一，但允许有空值。
### 复合索引
即一个索引包含多个列。
### 基本索引

## mysql索引结构和检索原理
### BTree索引

### Hash索引

### full-text全文索引

### R-Tree索引

## 哪些情况需要创建索引
1.主键自动建立唯一索引
2.频繁作为查询条件的字段应该创建索引
3.查询中与其他表关联的字段，外键关系建立索引
4.频繁更新的字段不适合创建索引，因为每次更新不单单是更新了记录还会更新索引列
5.where条件里用不到的字段不创建索引
6.单键/组合索引的选择问题，who？（在高并发下倾向创建组合索引）
7.查询中排序的字段，排序字段若通过索引区访问将大大提高排序速度。
8.查询中统计或者分组字段

## 哪些情况不要创建索引
1.表记录太少
2.经常增删的表
