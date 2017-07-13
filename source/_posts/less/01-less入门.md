---
title: 01-less入门
date: 2017-07-13 09:42:43
tags: [less,css]
---
## less入门
Less 是一门 CSS 预处理语言，它扩充了 CSS 语言，增加了诸如变量、混合（mixin）、函数等功能，让 CSS 更易维护、方便制作主题、扩充。

Less 可以运行在 Node、浏览器和 Rhino 平台上。网上有很多第三方工具帮助你编译 Less 源码。
<!-- more -->
例如:
```less
@charset "UTF-8";
//只会在LESS中显示
/*就会在LESS和CSS中显示*/
.conten {
  ul{
    list-style: none;
  }
  li{
    height: 25px;
    line-height: 25px;
    padding-left: 15px;
    background: url("arr.jpg") no-repeat center left;
    a{
      text-decoration: none;
      color: #535353;
      font-family: microsoft yahei, "微软雅黑", Arial, Simsun, "Arial Unicode MS", Mingliu, Helvetica;
    }
  }
}
```

编译为:
```
@charset "UTF-8";
/*就会在LESS和CSS中显示*/
.conten ul {
  list-style: none;
}
.conten li {
  height: 25px;
  line-height: 25px;
  padding-left: 15px;
  background: url("arr.jpg") no-repeat center left;
}
.conten li a {
  text-decoration: none;
  color: #535353;
  font-family: microsoft yahei, "微软雅黑", Arial, Simsun, "Arial Unicode MS", Mingliu, Helvetica;
}
```