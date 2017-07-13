---
title: 03-less混合
date: 2017-07-13 10:22:56
tags: [less,css]
---
## less混合
混合可以将一个定义好的class A轻松的引入到另一个class B中，从而简单实现class B继承class A中的所有属性。我们还可以带参数地调用，就像使用函数一样。
<!-- more -->
### 普通混合
.类名{} 
用法在需要添加的样式中加.类名
```
<!-- less -->
.font_hn{
  color: red;
  font-family: microsoft yahei, "黑体", Arial, Simsun, "Arial Unicode MS", Mingliu, Helvetica;
}
h1{
  font-size: 28px;
  .font_hn;
}
h2{
  font-size: 24px;
  .font_hn;
}
<!-- css -->
.font_hn {
  color: red;
  font-family: microsoft yahei, "黑体", Arial, Simsun, "Arial Unicode MS", Mingliu, Helvetica;
}
h1 {
  font-size: 28px;
  color: red;
  font-family: microsoft yahei, "黑体", Arial, Simsun, "Arial Unicode MS", Mingliu, Helvetica;
}
h2 {
  font-size: 24px;
  color: red;
  font-family: microsoft yahei, "黑体", Arial, Simsun, "Arial Unicode MS", Mingliu, Helvetica;
}
```

### 不带输出的混合,类名后面使用()
.类名(){} 
用法在需要添加的样式中加.类名
```
<!-- less -->
//不带输出的混合,类名后面使用()
.font_hn(){
  color: red;
  font-family: microsoft yahei, "黑体", Arial, Simsun, "Arial Unicode MS", Mingliu, Helvetica;
}
h1{
  font-size: 28px;
  .font_hn;
}
h2{
  font-size: 24px;
  .font_hn;
}
<!-- css -->
h1 {
  font-size: 28px;
  color: red;
  font-family: microsoft yahei, "黑体", Arial, Simsun, "Arial Unicode MS", Mingliu, Helvetica;
}
h2 {
  font-size: 24px;
  color: red;
  font-family: microsoft yahei, "黑体", Arial, Simsun, "Arial Unicode MS", Mingliu, Helvetica;
}
```

### 带选择器的混合
.类名(){&:hover{}} 
当鼠标滑过的效果,用法在需要添加的样式中加,类名
```
<!-- less -->
.my-hover-mixin {
  &:hover {
    border: 1px solid red;
  }
}
button {
  .my-hover-mixin();
}
h1{
  .my-hover-mixin();
}
<!-- css -->
.my-hover-mixin:hover {
  border: 1px solid red;
}
button:hover {
  border: 1px solid red;
}
h1:hover {
  border: 1px solid red;
}
```

### 带参数的混合
.类名(@变量){属性:@变量;}
用法在需要添加的样式中加,类名(参数)
```
<!-- less -->
.border(@color){
  border: 1px solid @color;
}
h1{
  &:hover{
    .border(green);
  }
}
h2{
  &:hover{
    .border(#000);
  }
}
<!-- css -->
h1:hover {
  border: 1px solid #008000;
}
h2:hover {
  border: 1px solid #000000;
}
```

### 带参数且有默认变量的混合
.类名(@变量:默认值){属性:@变量;}
用法在需要添加的样式中加,类名； 
```
<!-- less -->
.border_you(@color:red){
  border: 1px solid @color;
}
h1{
  &:hover{
    .border_you();
  }
}
h2{
  &:hover{
    .border_you(yellow);
  }
}
<!-- css -->
h1:hover {
  border: 1px solid #ff0000;
}
h2:hover {
  border: 1px solid #ffff00;
}
```

### 命名参数
```
<!-- less -->

<!-- css -->

```

### 带多个参数的混合
```
<!-- less -->

<!-- css -->

```

### 混合的返回值
```
<!-- less -->

<!-- css -->

```

