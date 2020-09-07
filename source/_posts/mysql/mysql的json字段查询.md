---
title: mysql的json字段查询
date: 2020-06-12 20:49:49
tags: mysql
---

## mysql对JSON数据进行查询

这篇文章主要介绍了mysql查询字段类型为json时的查询方式.
<!-- more -->

### 创建表

```sql
-- ----------------------------
-- Table structure for user_json
-- ----------------------------
DROP TABLE IF EXISTS `user_json`;
CREATE TABLE `user_json`  (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `data_json` json,
  PRIMARY KEY (`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_json
-- ----------------------------
INSERT INTO `user_json` VALUES (1, '{\"mail\": \"jiangchengyao@gmail.com\", \"name\": \"David\", \"address\": \"Shangahai\"}');
INSERT INTO `user_json` VALUES (2, '{\"mail\": \"amy@gmail.com\", \"name\": \"Amy\"}');
INSERT INTO `user_json` VALUES (3, '{\"input_1591829818808\": \"\", \"select_1591829823429\": \"累计参数\", \"switch_1591829820974\": false, \"checkbox_1591829830409\": [\"社会\"]}');

INSERT INTO `work-flow`.`user_json`(`uid`, `data_json`) VALUES (5, '{\"meter\": {\"item_id\": \"1002\", \"item_name\": \"水厂组态\"}, \"input_1591829818808\": \"\", \"select_1591829823429\": \"累计参数\", \"switch_1591829820974\": false, \"checkbox_1591829830409\": [\"社会\"]}');

SET FOREIGN_KEY_CHECKS = 1;
```

### 非法插入数据
```sql
-- 非法数据,插入的数据做JSON格式检查,会报错, 3140 - Invalid JSON text: "Invalid value." at position 1 in value for column 'user_json.data_json'.
insert into user_json values (NULL,"test");
```

### mysql对json字段查询

```sql

-- MySQL 5.7提供了一系列函数来高效地处理JSON字符，而不是需要遍历所有字符来查找
-- https://www.cnblogs.com/zoucaitou/p/4424575.html
-- https://blog.csdn.net/Code_shadow/article/details/100055002

SELECT
	json_extract ( data_json, '$.name' ),
	json_extract ( data_json, '$.address' ) ,
	json_extract ( data_json, '$.checkbox_1591829830409' ) 
FROM
	user_json;
	
-- 根据json数组查询，用 JSON_CONTAINS(字段, JSON_OBJECT('json属性', "内容"))
SELECT
	uid,
	JSON_CONTAINS ( data_json, JSON_OBJECT('select_1591829823429',"累计参数") ) 
FROM
	user_json;

SELECT
	uid,
	JSON_CONTAINS ( data_json, JSON_OBJECT('select_1591829823429',"累计参数") ) 
FROM
	user_json;
	
SELECT uid FROM user_json where JSON_CONTAINS( data_json -> '$[*]','["累计参数"]')

-- 使用 字段->’$.json属性’进行查询条件
select  * from user_json where data_json->'$.select_1591829823429' = '累计参数';

-- 用JSON_CONTAINS(字段,JSON_OBJECT(‘json属性’, “内容”))
select * from user_json where JSON_CONTAINS(data_json,JSON_OBJECT('select_1591829823429','累计参数'))

-- 需要对其中的f开头的Json key值所对的value进行模糊查询，方法如下：
select * from user_json where data_json->'$.select_1591829823429' LIKE '%累计%';


-- 找多层的json数据,条件查询,方法一
SELECT * FROM user_json WHERE json_extract(json_extract(data_json,"$.meter"),"$.item_name") = '水厂组态';
-- 找多层的json数据,条件查询,方法二
SELECT
    uid,
    json_extract( t.data_json, '$.meter.item_name' )
FROM
    user_json t
WHERE
    json_extract( t.data_json, '$.meter.item_name' )  = '水厂组态'; 

-- 多层
SELECT
	*
	,JSON_EXTRACT (`data_json`, '$.select_1591829823429')
	,JSON_EXTRACT (`data_json`, '$**.item_name')
FROM
	`user_json`
```
