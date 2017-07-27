---
title: mysql实现lastindexof的效果
date: 2017-07-12 09:10:35
tags: [lastindexof,mysql]
---
## mysql实现lastindexof的效果
需求:mysql 从某个位置往前截取字符串.
<!-- more -->
需要了解几个函数:
1. 字符串截取：left(str, length);
    select left('example.com', 3);  # exa

2. 字符串截取：right(str, length);
    select right('example.com', 3); # com

3. 字符串截取：substring(str, pos);  substring(str, pos, len)
3.1 从字符串的第 4 个字符位置开始取，直到结束
    select substring('example.com', 4); # mple.com

3.2 从字符串的第 4 个字符位置开始取,只取2个字符
    select substring('example.com', 4, 2); # mp

3.3 从字符串的第 4 个字符位置（倒数）开始取，直到结束。
    select substring('example.com', -4); # .com 

3.4 从字符串的第 4 个字符位置（倒数）开始取，只取 2 个字符。
    select substring('example.com', -4, 2); # .c

4. 反转字符串:reverse(str);
    select reverse('MP00'); # 00PM

5. 从第2位开始截取,到倒数第3位:
    select reverse(substring(reverse(substring('MP00abcadfds',2)),3)); # P00abcadf
6. 根据表中code字段的值,去掉后面2位,并拼接ft字符串,后将拼接好的字符串插入到type字段中.
```sql
drop procedure if exists updateFieldByOther;
delimiter //
create procedure updateFieldByOther()
begin 
  declare row_id varchar(50);
  declare row_code varchar(50);
  declare row_count int default 1;
  -- 声明游标
  declare getData cursor for select ID,code from `function` order by ID asc;
  -- 绑定控制变量到游标,游标循环结束自动转 row_count = 0
  declare continue handler for not found set row_count := 0; 
  -- 打开游标
  open getData; 
  -- fetch 的时候，取到的值一定要赋值给定义好的变量
  fetch getData into row_id,row_code;
  while row_count = 1 do
    # 根据表中code字段的值,去掉后面2位,并拼接ft字符串,后将拼接好的字符串插入到type字段中.
    update `function` set type = concat('ft',reverse(substring(reverse(row_code), 3))) where ID = row_id;
    fetch getData into row_id,row_code;
  end while;  
  -- 关闭游标
  close getData;
end //

-- 执行存储过程
call updateFieldByOther();
```

7. 最简单的方法:
获取字符串的长度: length(str);
select length('helloworld'); # 10

获取倒数第二位以前的字符串:
select substring('helloworld',1,length('helloworld') - 2) # hellowor









































