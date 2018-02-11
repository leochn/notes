---
title: mysql数据库优化02
date: 2017-09-30 16:51:58
tags: mysql
---
## explain 优化
explain为mysql提供语句的执行计划信息。可以应用在select、delete、insert、update和place语句上。explain的执行计划，只是作为语句执行过程的一个参考，实际执行的过程不一定和计划完全一致，但是执行计划中透露出的讯息却可以帮助选择更好的索引和写出更优化的查询语句。

<!-- more -->

在MySQL中可以使用EXPLAIN查看SQL执行计划，用法：EXPLAIN SELECT * FROM tb_item

![mmysql优化](/assets/images/mysql/mysql优化-explain001.png)

## explain查询结果
### id
SELECT识别符。这是SELECT查询序列号。这个不重要。

### select_type
表示SELECT语句的类型.有以下几种值：
1.SIMPLE
    表示简单查询，其中不包含连接查询和子查询。
2.PRIMARY
    表示主查询，或者是最外面的查询语句。

![mmysql优化](/assets/images/mysql/mysql优化-explain002.png)

3.UNION
表示连接查询的第2个或后面的查询语句

![mmysql优化](/assets/images/mysql/mysql优化-explain003.png)

4.DEPENDENT UNION
UNION中的第二个或后面的SELECT语句，取决于外面的查询。
5.UNION RESULT
连接查询的结果。
6.SUBQUERY
子查询中的第1个SELECT语句。

![mmysql优化](/assets/images/mysql/mysql优化-explain004.png)
7.DEPENDENT SUBQUERY
子查询中的第1个SELECT语句，取决于外面的查询。
8.DERIVED
SELECT(FROM 子句的子查询)。

### table
表示查询的表。

### type(重要)
表示表的连接类型。
以下的连接类型的顺序是从最佳类型到最差类型：
1.system
表仅有一行，这是const类型的特列，平时不会出现，这个也可以忽略不计。
2.const
数据表最多只有一个匹配行，因为只匹配一行数据，所以很快，常用于PRIMARY KEY或者UNIQUE索引的查询，可理解为const是*最优化*的。

![mmysql优化](/assets/images/mysql/mysql优化-explain005.png)
3.eq_ref
mysql手册是这样说的:"对于每个来自于前面的表的行组合，从该表中读取一行。这可能是最好的联接类型，除了const类型。它用在一个索引的所有部分被联接使用并且索引是UNIQUE或PRIMARY KEY"。eq_ref可以用于使用=比较带索引的列。

![mmysql优化](/assets/images/mysql/mysql优化-explain006.png)
4.ref
查询条件索引既不是UNIQUE也不是PRIMARY KEY的情况。ref可用于=或<或>操作符的带索引的列。

![mmysql优化](/assets/images/mysql/mysql优化-explain007.png)
5.ref_or_null
该联接类型如同ref，但是添加了MySQL可以专门搜索包含NULL值的行。在解决子查询中经常使用该联接类型的优化。

上面这五种情况都是很理想的索引使用情况。

6.index_merge
该联接类型表示使用了索引合并优化方法。在这种情况下，key列包含了使用的索引的清单，key_len包含了使用的索引的最长的关键元素。
7.unique_subquery
该类型替换了下面形式的IN子查询的ref: value IN (SELECT primary_key FROM single_table WHERE some_expr) 
unique_subquery是一个索引查找函数,可以完全替换子查询,效率更高。
8.index_subquery
该联接类型类似于unique_subquery。可以替换IN子查询,但只适合下列形式的子查询中的非唯一索引: value IN (SELECT key_column FROM single_table WHERE some_expr)
9.range
只检索给定范围的行,使用一个索引来选择行。

![mmysql优化](/assets/images/mysql/mysql优化-explain008.png)
10.index
该联接类型与ALL相同,除了只有索引树被扫描。这通常比ALL快,因为索引文件通常比数据文件小。
11.ALL
对于每个来自于先前的表的行组合,进行完整的表扫描。（性能最差）

### possible_keys
指出MySQL能使用哪个索引在该表中找到行。
如果该列为NULL，说明没有使用索引，可以对该列创建索引来提供性能。

### key
显示MySQL实际决定使用的键(索引)。如果没有选择索引,键是NULL。
可以强制使用索引或者忽略索引：

![mmysql优化](/assets/images/mysql/mysql优化-explain009.png)

### key_len
显示MySQL决定使用的键长度。如果键是NULL,则长度为NULL。

注意：key_len是确定了MySQL将实际使用的索引长度。

### ref
显示使用哪个列或常数与key一起从表中选择行。
### rows
显示MySQL认为它执行查询时必须检查的行数。
### Extra
该列包含MySQL解决查询的详细信息
•   Distinct:MySQL发现第1个匹配行后,停止为当前的行组合搜索更多的行。
•   Not exists:MySQL能够对查询进行LEFT JOIN优化,发现1个匹配LEFT JOIN标准的行后,不再为前面的的行组合在该表内检查更多的行。
•   range checked for each record (index map: #):MySQL没有发现好的可以使用的索引,但发现如果来自前面的表的列值已知,可能部分索引可以使用。
•   Using filesort:MySQL需要额外的一次传递,以找出如何按排序顺序检索行。
•   Using index:从只使用索引树中的信息而不需要进一步搜索读取实际的行来检索表中的列信息。
•   Using temporary:为了解决查询,MySQL需要创建一个临时表来容纳结果。
•   Using where:WHERE 子句用于限制哪一个行匹配下一个表或发送到客户。
•   Using sort_union(...), Using union(...), Using intersect(...):这些函数说明如何为index_merge联接类型合并索引扫描。
•   Using index for group-by:类似于访问表的Using index方式,Using index for group-by表示MySQL发现了一个索引,可以用来查 询GROUP BY或DISTINCT查询的所有列,而不要额外搜索硬盘访问实际的表。

## 使用索引查询需要注意
索引可以提供查询的速度，但并不是使用了带有索引的字段查询都会生效，有些情况下是不生效的，需要注意！

### 使用LIKE关键字的查询
在使用LIKE关键字进行查询的查询语句中，如果匹配字符串的第一个字符为“%”，索引不起作用。只有“%”不在第一个位置，索引才会生效。

![mmysql优化](/assets/images/mysql/mysql优化-explain010.png)

![mmysql优化](/assets/images/mysql/mysql优化-explain011.png)

### 使用联合索引的查询
MySQL可以为多个字段创建索引，一个索引可以包括16个字段。对于联合索引，只有查询条件中使用了这些字段中第一个字段时，索引才会生效。

![mmysql优化](/assets/images/mysql/mysql优化-explain012.png)

![mmysql优化](/assets/images/mysql/mysql优化-explain013.png)

![mmysql优化](/assets/images/mysql/mysql优化-explain014.png)

### 使用OR关键字的查询
查询语句的查询条件中只有OR关键字，且OR前后的两个条件中的列都是索引时，索引才会生效，否则，索引不生效。

![mmysql优化](/assets/images/mysql/mysql优化-explain015.png)

![mmysql优化](/assets/images/mysql/mysql优化-explain016.png)

![mmysql优化](/assets/images/mysql/mysql优化-explain017.png)

## 子查询优化
MySQL从4.1版本开始支持子查询，使用子查询进行SELECT语句嵌套查询，可以一次完成很多逻辑上需要多个步骤才能完成的SQL操作。

子查询虽然很灵活，但是执行效率并不高。

执行子查询时，MYSQL需要创建临时表，查询完毕后再删除这些临时表，所以，子查询的速度会受到一定的影响。

优化：
可以使用连接查询（JOIN）代替子查询，连接查询时不需要建立临时表，其速度比子查询快。









