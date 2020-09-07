---
title: postgresql常用函数01
date: 2020-03-14 10:21:08
tags: [postgresql]
---

## postgresql时间函数示例
```sql
-- extract函数是从日期或者时间数值里面抽取子域，比如年、月、日等	
select extract (year from timestamp '2017-07-31 22:18:00');

select extract (year FROM (age(now(),'2017-07-31 22:18:00')));

select age(now(),'2017-07-31 22:18:00');

```