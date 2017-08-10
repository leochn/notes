---
title: mysql关于级联删除
date: 2017-08-08 09:14:46
tags: [mysql,java]
---
对于有外键约束的字段，想要删除数据的时候，就要考虑到它的外键约束了。
<!-- more -->

## 有外键约束不进行删除操作
### xxxMapper.xml
```xml
    <update id="delete">
    DELETE FROM device WHERE id = #{id}
        and id not in (select id_device from device_set_info where id_device = #{id})
        and id not in (select id_device from device_pump where id_device = #{id})
        and id not in (select id_device from device_dispenser where id_device = #{id})
        and id not in (select id_device from device_control_carbinet where id_device = #{id})
        and id not in (select id_device from services where id_device = #{id})
        and id not in (select id_device from device_info where id_device = #{id})
    </update>
```

## 有外键约束进行级联删除