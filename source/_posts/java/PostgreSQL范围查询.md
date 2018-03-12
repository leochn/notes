---
title: PostgreSQL范围查询
date: 2018-03-12 12:30:41
tags: [java,PostgreSql,mybatis]
---
## Java,PostgreSQL时间范围查询
在业务中使用到了greenplum数据库，需要根据时间条件查询数据，项目中采用 postgresql 的驱动。发现在查询过程中能查出数据，但是执行查询需要很长时间。这是为什么呢？
<!-- more -->

如下图，查询花费9579ms
![postgresql数据库查询](/assets/images/java/postgresql查询001.png)

## 数据库连接驱动
数据库连接驱动配置如下：
```xml
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
</dependency>
```

## 发现问题
由于时间查询条件是按照之前mysql的写法直接复制过去的（时间范围是参数，类型为String）。
mapper接口如下：
```java
List<HistoryData> getHistoryData(@Param("type") String type, @Param("services") List<String> services, @Param("startTime") String startTime, @Param("endTime")  String endTime);
```

mybatis中sql：
```xml
    <select id="getHistoryData" resultType="com.example.entity.HistoryData">
        SELECT
            id_service AS idService,
            date_time  AS dateTime,
            max_data   AS maxData,
            min_data   AS minData,
            pv         AS avgData
        FROM
            service_values_${type}
        WHERE
            id_service IN (
                <foreach collection="services" item="item" separator=",">
                    #{item}
                </foreach>
            )
        AND date_time BETWEEN #{startTime} AND #{endTime}
        ORDER BY id_service ASC , date_time ASC
    </select>
```

打印的查询日志如下：
![postgresql数据库查询](/assets/images/java/postgresql查询002.png)

## 解决问题
将String类型的参数改为java.sql.Timestamp
```java
List<HistoryData> getHistoryData(@Param("type") String type, @Param("services") List<String> services, @Param("startTime") Timestamp startTime, @Param("endTime")  Timestamp endTime);
```

修改后，打印的查询日志如下：
![postgresql数据库查询](/assets/images/java/postgresql查询003.png)

修改后，查询耗时只有249ms，查询结果显示：
![postgresql数据库查询](/assets/images/java/postgresql查询004.png)

