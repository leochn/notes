---
title: mysql游标
date: 2017-06-05 16:30:26
tags: mysql
---
## mysql游标使用的需求:
根据一张表的数据结果,改变另外一张表字段的数据.

## 场景
如果 function_reference 表中的NAME,REL_NAME1,REL_NAME2,REL_NAME3,REL_NAME4,REL_NAME5,REL_NAME6,这些字段中的值与 points 表中 code 字段的值相等,则 function_reference 的ID值赋值给 points 表中的 ID_FUNCTION 字段.

```sql
CREATE TABLE `function_reference` (
  `ID` varchar(20) DEFAULT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  `REL_NAME1` varchar(50) DEFAULT NULL,
  `REL_NAME2` varchar(50) DEFAULT NULL,
  `REL_NAME3` varchar(50) DEFAULT NULL,
  `REL_NAME4` varchar(50) DEFAULT NULL,
  `REL_NAME5` varchar(50) DEFAULT NULL,
  `REL_NAME6` varchar(50) DEFAULT NULL,
  `MEMO` varchar(255) DEFAULT NULL,
  `DATA_TYPE` varchar(50) DEFAULT NULL,
  `UNIT` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

```sql
CREATE TABLE `points` (
  `ID` varchar(150) NOT NULL,
  `NAME` varchar(100) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `TYPE` varchar(100) DEFAULT NULL,
  `MEMO` varchar(255) DEFAULT NULL COMMENT '备注',
  `ID_DEVICE` varchar(100) DEFAULT NULL,
  `ID_SERVICE_GROUP` varchar(100) DEFAULT NULL COMMENT '属于几号水泵',
  `DATA_TYPE` varchar(100) DEFAULT NULL COMMENT '数据类型',
  `ID_FUNCTION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_service_device` (`ID_DEVICE`),
  KEY `ID_FUNCTION` (`ID_FUNCTION`),
  CONSTRAINT `fk_service_device` FOREIGN KEY (`ID_DEVICE`) REFERENCES `device` (`ID`),
  CONSTRAINT `services_ibfk_1` FOREIGN KEY (`ID_FUNCTION`) REFERENCES `function_reference` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

![数据结构](/assets/images/mysql/mysql-cursor001.png)

## mysql存储过程
```sql
-- 创建存储过程
drop procedure if exists updatePointsData;
delimiter //
create procedure updatePointsData()
begin 
  declare row_id varchar(50);
  declare row_name00 varchar(50);
  declare row_name01 varchar(50);
  declare row_name02 varchar(50);
  declare row_name03 varchar(50);
  declare row_name04 varchar(50);
  declare row_name05 varchar(50);
  declare row_name06 varchar(50);
  declare row_count int default 1;
  -- 声明游标
  declare getData cursor for select ID,name,REL_NAME1,REL_NAME2,REL_NAME3,REL_NAME4,REL_NAME5,REL_NAME6 from function_reference order by ID asc;
  -- 绑定控制变量到游标,游标循环结束自动转 row_count = 0
  declare continue handler for not found set row_count := 0; 
  -- 打开游标
  open getData; 
  -- fetch 的时候，取到的值一定要赋值给定义好的变量
  fetch getData into row_id,row_name00,row_name01,row_name02,row_name03,row_name04,row_name05,row_name06;
  while row_count = 1 do
    if !isnull(row_name00) then # isnull(expr) 的用法:如expr 为null,那么isnull() 的返回值为 1,否则返回值为 0.
      # 如果 row_name00 中的值不为 NULL ,则执行 update 语句.
      update points set ID_FUNCTION=row_id where code=row_name00;
    end if;
    if !isnull(row_name01) then
      update points set ID_FUNCTION=row_id where code=row_name01;
    end if;
    if !isnull(row_name02) then
      update points set ID_FUNCTION=row_id where code=row_name02;
    end if;
    if !isnull(row_name03) then
      update points set ID_FUNCTION=row_id where code=row_name03;
    end if;
    if !isnull(row_name04) then
      update points set ID_FUNCTION=row_id where code=row_name04;
    end if;
    if !isnull(row_name05) then
      update points set ID_FUNCTION=row_id where code=row_name05;
    end if;
    if !isnull(row_name06) then
      update points set ID_FUNCTION=row_id where code=row_name06;
    end if;
    fetch getData into row_id,row_name00,row_name01,row_name02,row_name03,row_name04,row_name05,row_name06;
  end while;  
  -- 关闭游标
  close getData;
end //

-- 执行存储过程
call updatePointsData();
```