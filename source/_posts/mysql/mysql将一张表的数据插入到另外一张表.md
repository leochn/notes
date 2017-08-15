---
title: mysql将一张表的数据插入到另外一张表
date: 2017-08-15 10:47:20
tags: mysql
---
## 表结构完全一样
 insert into 表1  select * from 表2

## 表结构不一样（这种情况下得指定列名）
  insert into 表1 (列名1,列名2,列名3) select 列1,列2,列3 from 表2

也可以是临时表
```sql
insert into device (ID,ID_PROJECT,ID_PUMP_HOUSE,TYPE,memo,NAME) 
SELECT 
    d1.device_id,
    d1.project_id,
    d1.house_id,
    d1.device_type,
    d1.memo,
    d1.`name`
from device d
RIGHT JOIN `devices1$` d1
on d.ID = d1.device_id
where d.ID is null 
```

## 只从另外一个表取部分值
insert into 表1 (列名1,列名2,列名3) values(列1,列2,(select 列3 from 表2));