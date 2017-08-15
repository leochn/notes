---
title: mybatis批量update
date: 2017-08-11 13:26:32
tags: [java,mybatis]
---
使用mysql 自带的语句构建批量更新
## sql语句
```sql
update sys_admin
    set user_name = case id
        when 01 then 'value1'
        when 02 then 'value2'
        when 03 then 'value3'
    end,
    email = case id
    when 01 then 'value1@163.com'
        when 02 then 'value2@163.com'
        when 03 then 'value3@163.com'
    end
where id in (01,02,03)
```
这句sql 的意思是，更新 user_name 和 email 字段，
如果id=01 则 user_name 的值为 value1，email 的值为 value1@163.com，
如果id=02 则 user_name 的值为 value2，email 的值为 value1@163.com ......
where部分不影响代码的执行，但是会提高sql执行的效率。确保sql语句仅执行需要修改的行数，这里只有3条数据进行更新，而where子句确保只有3行数据执行。

## xxxMapper.xml

```xml
  <update id="updateForBatch" parameterType="java.util.List">  
      update sys_user set  
      user_name=  
      <foreach collection="list" item="item" index="index" separator=" " open="case id" close="end">  
        when #{item.id,jdbcType=VARCHAR} then #{item.userName,jdbcType=VARCHAR}  
      </foreach>  
      ,email=  
      <foreach collection="list" item="item" index="index" separator=" " open="case id" close="end">  
        when #{item.id,jdbcType=VARCHAR} then #{item.email,jdbcType=VARCHAR}  
      </foreach> 
      where ID in  
      <foreach collection="list" index="index" item="item" separator="," open="(" close=")">  
        #{item.id,jdbcType=VARCHAR}  
      </foreach>  
  </update> 
```

## xxxMapper.java
```java
    public void updateForBatch(List<SysUser> list);
```

## xxxService.java
```java
    public void updateForBatch(List<SysUser> list) {
        sysUserMapper.updateForBatch(list);
    }
```

## xxxTest.java
```java
        ArrayList<SysUser> list = new ArrayList<SysUser>();
        SysUser sysUser0 = new SysUser();
        sysUser0.setUserName("hello0");
        sysUser0.setEmail("hello0@163.com");
        SysUser sysUser1 = new SysUser();
        sysUser1.setUserName("hello1");
        sysUser1.setEmail("hello1@163.com");
        SysUser sysUser2 = new SysUser();
        sysUser2.setUserName("hello2");
        sysUser2.setEmail("hello2@163.com");
        SysUser sysUser3 = new SysUser();
        sysUser3.setUserName("hello3");
        sysUser3.setEmail("hello3@163.com");
        sysUser0.setId("01");
        sysUser1.setId("02");
        sysUser2.setId("03");
        sysUser3.setId("04");
        list.add(sysUser0);
        list.add(sysUser1);
        list.add(sysUser2);
        list.add(sysUser3);
        this.sysUserService.updateForBatch(list);
```

## 打印的sql语句
```sql
update sys_user
  set user_name = case id 
    when ? then ? 
    when ? then ? 
    when ? then ? 
    when ? then ? 
  end,
  email = case id 
    when ? then ? 
    when ? then ? 
    when ? then ? 
    when ? then ? 
  end
where ID in(?, ?, ?, ?)
## Parameters: 01(String), hello0(String), 02(String), hello1(String), 03(String), hello2(String), 04(String), hello3(String), 01(String), hello0@163.com(String), 02(String), hello1@163.com(String), 03(String), hello2@163.com(String), 04(String), hello3@163.com(String), 01(String), 02(String), 03(String), 04(String)

```