---
title: mybatis无极限树形结构Mapperxml映射方法
date: 2017-08-15 15:25:24
tags: [java,mybatis]
---
项目中我们可能经常有这样的需求，需要返回二级、三级或者更多级的菜单，返回一个树形结构。这里采用地区表来演示。
<!-- more -->
## 数据库表及初始化数据
```sql
-- ----------------------------
-- Table structure for area
-- ----------------------------
DROP TABLE IF EXISTS `area`;
CREATE TABLE `area` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `area_name` varchar(50) NOT NULL COMMENT '地区名称',
  `parent_id` int(11) NOT NULL COMMENT '父Id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7668 DEFAULT CHARSET=utf8 COMMENT='地区表';

-- ----------------------------
-- Records of area
-- ----------------------------
INSERT INTO `area` VALUES ('1', '广东省', '0');
INSERT INTO `area` VALUES ('2', '深圳市', '1');
INSERT INTO `area` VALUES ('3', '广州市', '1');
INSERT INTO `area` VALUES ('4', '湖南省', '0');
INSERT INTO `area` VALUES ('5', '长沙市', '4');
INSERT INTO `area` VALUES ('6', '株洲市', '4');
INSERT INTO `area` VALUES ('7', '番禺区', '3');
INSERT INTO `area` VALUES ('8', '天河区', '3');
INSERT INTO `area` VALUES ('9', '天河区街道1', '8');
INSERT INTO `area` VALUES ('10', '天河区街道2', '8');
INSERT INTO `area` VALUES ('11', '天河区街道1社区01', '9');
INSERT INTO `area` VALUES ('12', '天河区街道1社区01-D地块', '11');
INSERT INTO `area` VALUES ('13', '天河区街道1社区01-D地块A栋楼', '12');
INSERT INTO `area` VALUES ('14', '深圳市罗湖区', '2');
```

## Area.java
```java
package com.vnext.pojo;
import java.util.List;
import javax.persistence.*;
public class Area {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "area_name")
    private String areaName;

    @Column(name = "parent_id")
    private Integer parentId;
    
    // 非数据库字段需要用 @Transient 注解
    @Transient
    List<Area> childrenList;
    
    public List<Area> getChildrenList() {
        return childrenList;
    }

    public void setChildrenList(List<Area> childrenList) {
        this.childrenList = childrenList;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getAreaName() {
        return areaName;
    }

    public void setAreaName(String areaName) {
        this.areaName = areaName;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }
}
```

## AreaMapper.java
```java
public interface AreaMapper extends MyMapper<Area> {
    public Area queryTreeById(String id);
}
```

## AreaService.java
```java
@Service
public class AreaService extends BaseService<Area> {
    @Autowired
    private AreaMapper areaMapper;

    public Area queryTreeById(String id) {
        return this.areaMapper.queryTreeById(id);
    }
}
```

## AreaController.java
```java
    @GetMapping("/area/{id}")
    public Result detail(@PathVariable String id) {
        Area record = this.areaService.queryTreeById(id);
        if (record != null) {
            return ResultGenerator.genSuccessResult(1,record);
        }
        return ResultGenerator.genNotFoundResult();
    }
```

## AreaMapper.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.vnext.mapper.AreaMapper">

    <resultMap id="baseAreaResult" type="com.vnext.pojo.Area">
        <id column="id" jdbcType="INTEGER" property="id" />
        <result column="area_name" jdbcType="VARCHAR" property="areaName" />
        <result column="parent_id" jdbcType="INTEGER" property="parentId" />
        <collection property="childrenList" javaType="java.util.ArrayList"
            column="id" ofType="com.vnext.pojo.Area" select="childrenSelect"></collection>
    </resultMap>
    <!--    
        collection 标签中定义属性名称为 childrenList，对应实体类com.vnext.pojo.Area中的：childrenList
        属性类型为：Java.util.ArrayList
        column="id" 将 id 列的值做为参数传递给子查询
        ofType 定义List 中保存的数据类型
        select 定义子查询 
    -->

    <resultMap id="childrenResult" type="com.vnext.pojo.Area">
        <id column="id" jdbcType="INTEGER" property="id" />
        <result column="area_name" jdbcType="VARCHAR" property="areaName" />
        <result column="parent_id" jdbcType="INTEGER" property="parentId" />
        <collection property="childrenList" javaType="java.util.ArrayList"
            column="id" ofType="com.vnext.pojo.Area" select="childrenSelect"></collection>
    </resultMap>
    

    <select id="queryTreeById" resultMap="baseAreaResult">
        SELECT
        id,area_name,parent_id
        FROM area
        where id = #{id}
    </select>

    <!-- 子查询 childrenSelect 对应的结果映射 childrenResult ，又包含了 collection 标签，形成了循环递归调用 -->
    <select id="childrenSelect" resultMap="childrenResult">
        SELECT
        id,area_name,parent_id
        FROM area
        WHERE parent_id = #{id}
        ORDER BY id ASC
    </select>

</mapper>
```

## api接口实现的json格式
http://localhost:8087/api/area/1
```json
{
    "code": 200,
    "message": "SUCCESS",
    "total": 1,
    "data": {
        "id": 1,
        "areaName": "广东省",
        "parentId": 0,
        "childrenList": [
            {
                "id": 2,
                "areaName": "深圳市",
                "parentId": 1,
                "childrenList": [
                    {
                        "id": 14,
                        "areaName": "深圳市罗湖区",
                        "parentId": 2,
                        "childrenList": []
                    }
                ]
            },
            {
                "id": 3,
                "areaName": "广州市",
                "parentId": 1,
                "childrenList": [
                    {
                        "id": 7,
                        "areaName": "番禺区",
                        "parentId": 3,
                        "childrenList": []
                    },
                    {
                        "id": 8,
                        "areaName": "天河区",
                        "parentId": 3,
                        "childrenList": [
                            {
                                "id": 9,
                                "areaName": "天河区街道1",
                                "parentId": 8,
                                "childrenList": [
                                    {
                                        "id": 11,
                                        "areaName": "天河区街道1社区01",
                                        "parentId": 9,
                                        "childrenList": [
                                            {
                                                "id": 12,
                                                "areaName": "天河区街道1社区01-D地块",
                                                "parentId": 11,
                                                "childrenList": [
                                                    {
                                                        "id": 13,
                                                        "areaName": "天河区街道1社区01-D地块A栋楼",
                                                        "parentId": 12,
                                                        "childrenList": []
                                                    }
                                                ]
                                            }
                                        ]
                                    }
                                ]
                            },
                            {
                                "id": 10,
                                "areaName": "天河区街道2",
                                "parentId": 8,
                                "childrenList": []
                            }
                        ]
                    }
                ]
            }
        ]
    }
}
```

## 小结
这种递归的方式可以实现无极限的树形结构，但是递归的方式性能会比较差。
如果业务系统很明确有几级，那就直接写几级，也就是写几个 resultMap。






