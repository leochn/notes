---
title: 10-less条件表达
date: 2017-07-14 06:07:28
tags: less
---
## less条件表达

### 带条件的混合
比较运算符: > , >= , = , =< , true
```
<!-- less -->
.mixin (@a) when (lightness(@a) >= 50%) {   //255/2=127.5
  background-color: black;
}
.mixin (@a) when (lightness(@a) < 50%) {
  background-color: white;
}
.mixin (@a) {
  color: @a;
}
.class1 { .mixin(#7e7e7e) }  //221  > 127.5  >50%  background-color: black;  7e7
.class2 { .mixin(#808080) }  //85 <127.5  <50%   background-color: white;  80808
<!-- css -->
.class1 {
  background-color: white;
  color: #7e7e7e;
}
.class2 {
  background-color: black;
  color: #808080;
}
```

### 类型检查函数
```
<!-- less -->
//iscolor,isnumber.....判断值得类型
.mixin (@a) when (iscolor(@a)) {   //255/2=127.5
  background-color: black;
}
.mixin (@a) when (isnumber(@a) ) {
  background-color: white;
  shuzi:shuzi;
}
.mixin (@a) {
  color: @a;
}
.class1 { .mixin(#7e7e7e) }  //background-color: black;
.class2 { .mixin(123) }  //background-color: white;
<!-- css -->
.class1 {
  background-color: black;
  color: #7e7e7e;
}
.class2 {
  background-color: white;
  shuzi: shuzi;
  color: 123;
}
```

### 单位检查函数
```
<!-- less -->
//ispixel,ispercentage.....单位检查函数
.mixin (@a) when (ispixel(@a)) {
  background-color: black;
}
.mixin (@a) when (ispercentage(@a) ) {
  background-color: white;
}
.mixin (@a) {
  width: @a;
}
.class1 { .mixin(960px) }  //background-color: black; width:960px
.class2 { .mixin(95%) }    //background-color: white;width:95%
<!-- css -->
.class1 {
  background-color: black;
  width: 960px;
}
.class2 {
  background-color: white;
  width: 95%;
}
```