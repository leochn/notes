---
title: mysql中in和exists和distinct
date: 2018-06-08 06:18:48
tags: [mysql,exists,distinct]
---
## mysql中exists的使用
使用exists代替in+使用exists代替distinct
<!-- more -->

## 表数据结构

```sql
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `departmentName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

INSERT INTO `department` VALUES ('1', '财务部');
INSERT INTO `department` VALUES ('2', '行政部');
INSERT INTO `department` VALUES ('3', '办公室');
INSERT INTO `department` VALUES ('4', '安保部');
INSERT INTO `department` VALUES ('5', '一厂');
INSERT INTO `department` VALUES ('6', '二厂');
INSERT INTO `department` VALUES ('7', '三厂');
INSERT INTO `department` VALUES ('8', '研发1');
INSERT INTO `department` VALUES ('9', '研发2');

DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lastName` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `gender` int(2) DEFAULT NULL,
  `d_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

INSERT INTO `employee` VALUES ('1', 'zhangsan', null, null, '1');
INSERT INTO `employee` VALUES ('2', 'lisi', null, null, '1');
INSERT INTO `employee` VALUES ('3', 'lisi2', null, null, '2');
INSERT INTO `employee` VALUES ('4', 'wangwu', null, null, '8');
INSERT INTO `employee` VALUES ('5', 'wangwu2', null, null, '8');
INSERT INTO `employee` VALUES ('6', 'tone', null, null, '9');
```

## 使用exists代替in 
exists只检查行的存在性，in 检查实际的值，所以existsd的性能比in好 

```sql
select * from employee
where d_id in(select  id from department where  departmentName ='研发1');

select * from employee e
where exists (select 1 from department  dep where  dep.id = e.d_id AND dep.departmentName ='研发1');

SELECT
    e.*
FROM
    employee e
inner JOIN department dep ON dep.id = e.d_id
AND dep.departmentName = '研发1'
```

## 使用exists代替distinct 
exists只检查行的存在性，distinct用于禁止重复行的显示，而且distinct在禁止重复行的显示前需要排序检索的行，所以exists的性能比distinct好 

```sql
SELECT DISTINCT
    e.d_id,
    d.departmentName
FROM
    employee e,
    department d
WHERE
    e.d_id = d.id;


select  d.id,d.departmentName  from department d
where exists(select 1 from employee e where e.d_id=d.id);
```