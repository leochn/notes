---
title: spirngboot之mybatis返回json数据IE浏览器乱码问题
date: 2018-02-11 10:05:14
tags: [java,mybatis]
---
## springboot返回json数据IE浏览器乱码问题
之前用springboot开发了一个接口，返回给前端，chrome浏览器接收的json数据是正常的，没有中文乱码的问题，但是IE(11.0.20)会出现中文乱码。更为奇怪的是在IE中，只有一个接口是出现乱码的？这是为什么呢？真实诡异...
<!-- more -->
IE浏览器版本:
![IE浏览器版本](/assets/images/java/IE乱码-IE浏览器的版本.png)

返回json数据乱码:
![返回json数据乱码](/assets/images/java/IE乱码-返回json数据乱码.png)

## 查找原因
代码都是用统一的框架开发的，但是只有这个接口，IE接收的json数据是乱码的，这就很奇怪了。查看代码，没有UTF-8编码问题.

于是找到sql语句，如下：
```sql
<resultMap type="com.xxx.dto.treeNode.PumphouseInfo" id="pumpHouseMap">
    <id column="pumpHouse_id" property="id" />
    <result column="pumpHouse_address" property="address" />
    <collection property="deviceInfoList" ofType="com.xxx.dto.treeNode.DeviceInfo">
        <id column="device_id" property="id" />
        <result column="device_name" property="deviceName"/>
        <result column="device_model" property="deviceModel"/>
        <result column="photo_url" property="photoUrl"/>
        <collection property="serviceInfoList" ofType="com.xxx.dto.treeNode.ServiceInfo">
            <id column="service_code" property="serviceCode" />
            <result column="service_unit" property="serviceUnit"/>
            <result column="service_name" property="serviceName"/>
        </collection>
    </collection>
</resultMap>
```

感觉sql语句也没有什么问题，唯一值得怀疑的地方是ServiceInfo类没有id这个属性，问题可能出现在这里，于是，把serviceCode属性名字改为id。然后再请求，发现IE请求响应的json数据没有中文乱码了。

json数据正常:
![json数据正常](/assets/images/java/IE乱码-json数据正常.png)


