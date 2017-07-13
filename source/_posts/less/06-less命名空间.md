---
title: 06-less命名空间
date: 2017-07-14 05:57:32
tags: less
---
## less命名空间
less命名空间: 将一些需要的混合组合在一起,可以通过嵌套多层id或者class来实现.
<!-- more -->
### 完整写法
```
<!-- less -->
#bgcolor(){
  background: #ffffff;
  .a{
    color: #888888;
    &:hover{
      color: #ff6600;
    }
    .b{
      background: #ff0000;
    }
  }
}
.wi{
  background: green;
  color: #fff;
  .a{
    color: green;
    background: #ffffff;
  }
}
.bgcolor1{
  background: #fdfee0;
  #bgcolor>.a;
}
.bgcolor2{
 .wi>.a;
}
<!-- css -->
.wi {
  background: green;
  color: #fff;
}
.wi .a {
  color: green;
  background: #ffffff;
}
.bgcolor1 {
  background: #fdfee0;
  color: #888888;
}
.bgcolor1:hover {
  color: #ff6600;
}
.bgcolor1 .b {
  background: #ff0000;
}
.bgcolor2 {
  color: green;
  background: #ffffff;
}
```

### 省略>写法
```
<!-- less -->
#bgcolor(){
  background: #ffffff;
  .a{
    color: #888888;
    &:hover{
      color: #ff6600;
    }
    .b{
      background: #ff0000;
    }
  }
}
.wi {
  background: green;
  color: #fff;
  .a {
    color: green;
    background: #ffffff;
  }
}
.bgcolor1{
  background: #fdfee0;
  #bgcolor .a;
}
.bgcolor2{
  .wi .a;
}
<!-- css -->
.wi {
  background: green;
  color: #fff;
}
.wi .a {
  color: green;
  background: #ffffff;
}
.bgcolor1 {
  background: #fdfee0;
  color: #888888;
}
.bgcolor1:hover {
  color: #ff6600;
}
.bgcolor1 .b {
  background: #ff0000;
}
.bgcolor2 {
  color: green;
  background: #ffffff;
}
```