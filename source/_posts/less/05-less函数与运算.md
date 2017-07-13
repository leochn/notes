---
title: 05-less函数与运算
date: 2017-07-13 10:57:26
tags: less
---
## ## less运算
运算提供了加，减，乘，除操作；我们可以做属性值和颜色的运算，这样就可以实现属性值之间的复杂关系。LESS中的函数一一映射了JavaScript代码，如果你愿意的话可以操作属性值。
<!-- more -->
```
<!-- less -->
.wp{
  margin: 0 auto;
  background: forestgreen;
  width: 450px + 450;
  height: 400 + 400px;
}
<!-- css -->
.wp {
  margin: 0 auto;
  background: forestgreen;
  width: 900px;
  height: 800px;
}
```

```
<!-- less -->
//涉及到优先级，使用()区分优先级
.wp{
  margin: 0 auto;
  width: (550 - 50)*2 + 24px;
  height: 400 + 400px;
  background:#ff0000 - 55;  //#000021   c8c8c8
}
<!-- css -->
.wp {
  margin: 0 auto;
  width: 1024px;
  height: 800px;
  background: #c80000;
}

```

```
<!-- less -->
@the-border: 1px;
@base-color: #111;
@red:        #842210;
#header {
  color: @base-color * 3;
  border-left: @the-border;
  border-right: @the-border * 2;
}
#footer { 
  color: @base-color + #003300;
  border-color: desaturate(@red, 10%);
}
<!-- css -->
#header {
  color: #333333;
  border-left: 1px;
  border-right: 2px;
}
#footer {
  color: #114411;
  border-color: #7d2717;
}
```

## less函数
less提供了许多用于转换颜色,处理字符串和进行算术运算的函数,这些函数使用起来非常简单.
常见的rgb()函数,将rgb模式的值转换为16进制的值.
```
<!-- less -->
.wp {
  background: #ff0000;
  z-index: rgb(0,133,0);
}
<!-- css -->
.wp {
  background: #ff0000;
  z-index: #008500;
}
```