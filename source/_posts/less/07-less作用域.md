---
title: 07-less作用域
date: 2017-07-14 06:05:53
tags: less
---
## less作用域
less中的作用域和编程语言中的作用域概念非常相似,首先会在局部查找变量和混合,如果没有找到,编译器就会在父作用域中查找,以此类推.
<!-- more -->
```
<!-- less -->
@clolor:#ffffff;
.bgcolor{
  width: 50px;
  a{
    color: @clolor;
  }
  @clolor:#ff0000;
}
<!-- css -->
.bgcolor {
  width: 50px;
}
.bgcolor a {
  color: #ff0000;
}
```

```
<!-- less -->
@clolor:#ffffff;
.bgcolor{
  width: 50px;
  a{
    color: @clolor;
  }
}
@clolor:#ff0001;
<!-- css -->
.bgcolor {
  width: 50px;
}
.bgcolor a {
  color: #ff0001;
}
```