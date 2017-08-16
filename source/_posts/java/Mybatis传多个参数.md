---
title: Mybatis传多个参数
date: 2017-08-10 15:16:27
tags: [java,mybatis]
---
Mybatis传多个参数,大概有三种方案
<!-- more -->

## 第一种方案 
DAO层的函数方法 
```java
Public User selectUser(String name,String area);
```

对应的Mapper.xml  
```xml
<select id="selectUser" resultMap="BaseResultMap">
    select * from user_user_t  where user_name = #{0} and user_area=#{1}
</select>
```
其中，#{0}代表接收的是dao层中的第一个参数，#{1}代表dao层中第二参数，更多参数一致往后加即可。

## 第二种方案

此方法采用Map传多参数.
Dao层的函数方法
```java
Public User selectUser(Map paramMap);
```

对应的Mapper.xml
```xml
<select id=" selectUser" resultMap="BaseResultMap">
   select * from user_user_t   where user_name = #{userName,jdbcType=VARCHAR} and user_area=#{userArea,jdbcType=VARCHAR}
</select>
```

Service层调用
```java
Private User xxxSelectUser(){
    Map paramMap=new hashMap();
    paramMap.put("userName","对应具体的参数值");
    paramMap.put("userArea","对应具体的参数值");
    User user=xxx.selectUser(paramMap);
}
```
此方法不够直观，见到接口方法不能直接的知道要传的参数是什么。

## 第三种方案

Dao层的函数方法
```java
Public User selectUser(@Param("userName")String name,@Param("userArea")String area);
```

对应的Mapper.xml
```xml
<select id="selectUser" resultMap="BaseResultMap">
   select * from user_user_t  where user_name = #{userName,jdbcType=VARCHAR} and user_area=#{userArea,jdbcType=VARCHAR}
</select> 
```
这种方法比较好，能让开发者看到dao层方法就知道该传什么样的参数，比较直观，个人推荐用此种方案。