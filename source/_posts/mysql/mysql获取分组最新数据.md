---
title: mysql获取分组最新数据
date: 2017-12-18 17:30:40
tags: mysql
---
## 需求
mysql的 GROUP BY 分组功能没有排序功能，所以我们如果想取出某个分组下的最新记录是不太容易的，下面介绍一种方法。
<!-- more -->
数据源如下:

![mysql获取分组最新数据](/assets/images/mysql/mysql获取分组最新数据01.png)

需要获取的数据如下:

![mysql获取分组最新数据](/assets/images/mysql/mysql获取分组最新数据02.png)

## 方案:通过同表子查询或同表关联查找到最大的数据ID

```sql
-- 同表子查询
SELECT
    *
FROM
    org_user_coordinate
WHERE
    id IN (
        SELECT
            MAX(id) AS id
        FROM
            org_user_coordinate
        GROUP BY
            user_id
    )

-- 同表关联查询
SELECT
    *
FROM
    org_user_coordinate ouc
RIGHT JOIN(
        SELECT
            MAX(id) AS id
        FROM
            org_user_coordinate
        GROUP BY
            user_id
    ) AS t
ON t.id = ouc.id
```

## 表结构
```sql
CREATE TABLE `org_user_coordinate` (
  `id` bigint(18) NOT NULL COMMENT 'id',
  `user_id` bigint(18) NOT NULL COMMENT '用户ID',
  `user_status` tinyint(1) DEFAULT NULL COMMENT '状态',
  `longi` varchar(15) DEFAULT NULL COMMENT '经度',
  `lati` varchar(15) DEFAULT NULL COMMENT '纬度',
  `position` varchar(100) DEFAULT NULL COMMENT '位置',
  `upload_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='人员?';

```

## 基础数据
```sql
INSERT INTO `watermis`.`org_user_coordinate` (`id`, `user_id`, `user_status`, `longi`, `lati`, `position`, `upload_time`) VALUES ('942687378457882625', '930567085725405185', '1', '1', '1', '1', '2017-12-18 15:35:43');
INSERT INTO `watermis`.`org_user_coordinate` (`id`, `user_id`, `user_status`, `longi`, `lati`, `position`, `upload_time`) VALUES ('942687433164115970', '930567085725405185', '1', '1', '1', '1', '2017-12-18 15:36:53');
INSERT INTO `watermis`.`org_user_coordinate` (`id`, `user_id`, `user_status`, `longi`, `lati`, `position`, `upload_time`) VALUES ('942687476826775553', '930567085725405185', '1', '1', '1', '1', '2017-12-18 15:37:05');
INSERT INTO `watermis`.`org_user_coordinate` (`id`, `user_id`, `user_status`, `longi`, `lati`, `position`, `upload_time`) VALUES ('942687532187418625', '933135697882173442', '1', '1', '1', '1', '2017-12-18 16:58:28');
INSERT INTO `watermis`.`org_user_coordinate` (`id`, `user_id`, `user_status`, `longi`, `lati`, `position`, `upload_time`) VALUES ('942687574671507457', '933135697882173442', '1', '1', '1', '1', '2017-12-18 16:58:38');
INSERT INTO `watermis`.`org_user_coordinate` (`id`, `user_id`, `user_status`, `longi`, `lati`, `position`, `upload_time`) VALUES ('942687617549905921', '933135697882173442', '1', '1', '1', '1', '2017-12-18 16:59:45');
INSERT INTO `watermis`.`org_user_coordinate` (`id`, `user_id`, `user_status`, `longi`, `lati`, `position`, `upload_time`) VALUES ('942687661732691969', '933135697882173442', '1', '1', '1', '1', '2017-12-18 17:22:10');
INSERT INTO `watermis`.`org_user_coordinate` (`id`, `user_id`, `user_status`, `longi`, `lati`, `position`, `upload_time`) VALUES ('942687712190140417', '933509267024039937', '1', '1', '1', '1', '2017-12-18 17:22:33');

```