---
title: mybatis批量插入数据
date: 2017-08-08 09:30:30
tags: [java,mybatis]
---
由于项目需要生成多条数据，并保存到数据库当中，在程序中封装了一个List集合对象，然后需要把该集合中的实体插入到数据库中,项目使用了Spring+MyBatis，所以打算使用MyBatis批量插入，应该要比循环插入的效果更好。
<!-- more -->
## xxxMapper.xml

```xml
    <insert id="batchInsertServices" parameterType="java.util.List" >
        insert into services(ID,NAME,code,MEMO,ID_DEVICE,DATA_TYPE,UNIT,ID_FUNCTION) 
        values 
        <foreach collection="list" item="item" index="index" separator="," >  
            (#{item.id},#{item.name},#{item.code},#{item.memo},#{item.idDevice},#{item.dataType},#{item.unit},#{item.idFunction}) 
        </foreach> 
    </insert>
```

## xxxMapper.java
```java
    public Integer batchInsertServices(List<ServicesImport> list);
```

## xxxService.java
```java
    // .........
    List<FunctionExt> functions = servicesImportDao.getFunctionByDeviceType(entity.getType());
    if (functions != null && functions.size() > 0) {
        List<ServicesImport> list = new ArrayList<ServicesImport>();
        for (int i = 0; i < functions.size(); i++) {
            FunctionExt item = functions.get(i);
            ServicesImport servicesImport = new ServicesImport();
            servicesImport.setId(entity.getId() + "\\" + item.getName()); 
            servicesImport.setName(item.getMemo());
            servicesImport.setCode(item.getName());
            servicesImport.setMemo(entity.getId() + "\\" + item.getMemo());
            servicesImport.setIdDevice(entity.getId());
            servicesImport.setDataType(item.getDataType());
            servicesImport.setUnit(item.getUnit());
            servicesImport.setIdFunction(item.getId());
            list.add(servicesImport); // 将数据添加到集合中.
        }
        Integer num = this.servicesImportMapper.batchInsertServices(list);
        return num;
    }
```

## 说明
对于foreach标签的解释参考了网上的资料，具体如下：

foreach的主要用在构建in条件中，它可以在SQL语句中进行迭代一个集合。

foreach元素的属性主要有 item，index，collection，open，separator，close。

item表示集合中每一个元素进行迭代时的别名，index指定一个名字，用于表示在迭代过程中，每次迭代到的位置，open表示该语句以什么开始，separator表示在每次进行迭代之间以什么符号作为分隔 符，close表示以什么结束，在使用foreach的时候最关键的也是最容易出错的就是collection属性，该属性是必须指定的，但是在不同情况 下，该属性的值是不一样的，主要有一下3种情况：

1.如果传入的是单参数且参数类型是一个List的时候，collection属性值为list

2.如果传入的是单参数且参数类型是一个array数组的时候，collection的属性值为array

3.如果传入的参数是多个的时候，我们就需要把它们封装成一个Map了，当然单参数也可以封装成map

## 打印日志
```
2016-08-08 09:28:25,253 DEBUG [modules.dao.ServicesImportMapper.batchInsertServices] - ==>  Preparing: insert into services(ID,NAME,code,MEMO,ID_DEVICE,DATA_TYPE,UNIT,ID_FUNCTION) values (?,?,?,?,?,?,?,?) , (?,?,?,?,?,?,?,?) , (?,?,?,?,?,?,?,?) , (?,?,?,?,?,?,?,?) , (?,?,?,?,?,?,?,?) , (?,?,?,?,?,?,?,?) , (?,?,?,?,?,?,?,?) , (?,?,?,?,?,?,?,?) , (?,?,?,?,?,?,?,?) ,  (?,?,?,?,?,?,?,?) , (?,?,?,?,?,?,?,?) , (?,?,?,?,?,?,?,?) , (?,?,?,?,?,?,?,?) , (?,?,?,?,?,?,?,?) 
```

