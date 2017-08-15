---
title: mysql从一张表update字段到另外一张表中
date: 2017-08-15 13:27:40
tags: mysql
---
方法一:
update 更新表 set 字段 = (select 参考数据 from 参考表 where  参考表.id = 更新表.id);
update table_2 m  set m.column = (select column from table_1 mp where mp.id= m.id);

方法二：
　　update table_1 t1,table_2 t2 set t1.column = t2.column where t1.id = t2.pid;

详细实例:
<!-- more -->

## 数据库表
```sql
CREATE TABLE `functions` (
  `ID` varchar(10) NOT NULL,
  `CODE` varchar(10) DEFAULT NULL COMMENT '代码',
  `DATA_TYPE` varchar(255) DEFAULT NULL COMMENT '数据类型',
  `UNIT` varchar(255) DEFAULT NULL COMMENT '单位',
  `RATIO` decimal(5,2) DEFAULT NULL COMMENT '倍率',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='点表';

CREATE TABLE `points` (
  `ID` varchar(150) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `DATA_TYPE` varchar(100) DEFAULT NULL COMMENT '数据类型',
  `ID_FUNCTION` varchar(50) DEFAULT NULL,
  `RATIO` decimal(5,3) DEFAULT NULL COMMENT '倍率',
  `UNIT` varchar(50) DEFAULT NULL COMMENT '单位',
  PRIMARY KEY (`ID`),
  KEY `ID_FUNCTION` (`ID_FUNCTION`),
  CONSTRAINT `points_copy_ibfk_2` FOREIGN KEY (`ID_FUNCTION`) REFERENCES `functions` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='设备点表';

## function
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('001', 'MP00', 'uint', 'Mpa', '0.01');
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('002', 'MP01', 'uint', 'Mpa', '0.01');
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('003', 'MP02', 'uint', 'Mpa', '0.01');
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('004', 'MP03', 'uint', 'Mpa', '0.01');
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('005', 'MP04', 'uint', 'Mpa', '0.01');
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('006', 'MP05', 'uint', 'Mpa', '0.01');
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('007', 'MP06', 'uint', 'Mpa', '0.01');
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('008', 'MP07', 'uint', 'Mpa', '0.01');
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('009', 'MP08', 'uint', 'Mpa', '0.01');
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('010', 'MP09', 'uint', 'Mpa', '0.01');
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('011', 'AC00', 'real', 'A', '1.00');
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('012', 'AC01', 'real', 'Hz', '1.00');
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('013', 'AC02', 'real', 'rpm', '1.00');
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('014', 'AC03', 'real', '℃', '1.00');
INSERT INTO `functions` (`ID`, `CODE`, `DATA_TYPE`, `UNIT`, `RATIO`) VALUES ('015', 'AC04', 'real', 'V', '1.00');

## points
INSERT INTO `points` (`ID`, `code`, `DATA_TYPE`, `ID_FUNCTION`, `RATIO`, `UNIT`) VALUES ('12083189\\active_power', 'active_power', NULL, '001', NULL, NULL);
INSERT INTO `points` (`ID`, `code`, `DATA_TYPE`, `ID_FUNCTION`, `RATIO`, `UNIT`) VALUES ('12083189\\BoosterPumpAlarm', 'BoosterPumpAlarm', NULL, '002', NULL, NULL);
INSERT INTO `points` (`ID`, `code`, `DATA_TYPE`, `ID_FUNCTION`, `RATIO`, `UNIT`) VALUES ('12083189\\BoosterPumpDelayTime', 'BoosterPumpDelayTime', NULL, '010', NULL, NULL);
INSERT INTO `points` (`ID`, `code`, `DATA_TYPE`, `ID_FUNCTION`, `RATIO`, `UNIT`) VALUES ('12083189\\BoosterPumpOutletPressure', 'BoosterPumpOutletPressure', NULL, '003', NULL, NULL);
INSERT INTO `points` (`ID`, `code`, `DATA_TYPE`, `ID_FUNCTION`, `RATIO`, `UNIT`) VALUES ('12083189\\BoosterPumpRun', 'BoosterPumpRun', NULL, '006', NULL, NULL);
INSERT INTO `points` (`ID`, `code`, `DATA_TYPE`, `ID_FUNCTION`, `RATIO`, `UNIT`) VALUES ('12083189\\CumulativeFlow', 'CumulativeFlow', NULL, '008', NULL, NULL);
INSERT INTO `points` (`ID`, `code`, `DATA_TYPE`, `ID_FUNCTION`, `RATIO`, `UNIT`) VALUES ('12083189\\DeviceState', 'DeviceState', NULL, '011', NULL, NULL);
INSERT INTO `points` (`ID`, `code`, `DATA_TYPE`, `ID_FUNCTION`, `RATIO`, `UNIT`) VALUES ('12083189\\DoorAccess', 'DoorAccess', NULL, '007', NULL, NULL);
INSERT INTO `points` (`ID`, `code`, `DATA_TYPE`, `ID_FUNCTION`, `RATIO`, `UNIT`) VALUES ('12083189\\door_state', 'door_state', NULL, '002', NULL, NULL);

```

## 根据 functions 表的字段值更新 points 表
三种方式:
```sql
 ## 方式1
update points s set s.DATA_TYPE = (SELECT DATA_TYPE from `functions` f where  f.ID = s.ID_FUNCTION);

 ## 方式2
update points s,`functions` f 
        set s.DATA_TYPE = f.DATA_TYPE ,s.RATIO = f.RATIO ,s.UNIT = f.UNIT
where s.ID_FUNCTION = f.ID;

 ## 方式3
update points s INNER JOIN `functions` f 
on s.ID_FUNCTION = f.ID 
set s.DATA_TYPE = f.DATA_TYPE ,s.RATIO = f.RATIO;
```



