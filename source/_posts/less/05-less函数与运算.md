---
title: 05-less函数与运算
date: 2017-07-13 10:57:26
tags: less
---
## less函数与运算
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