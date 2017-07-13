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

### @arguments变量
A. @arguments:代表所有可变参数,参数的先后哦顺序就是你的()括号内的参数的先后顺序.
B. 在使用过程中,值的位置和个数也是一一对应的,只有一个值,把值赋给第一个,
   两个值,赋值给第一和第二个,三个值,分别赋值给3个.
   如果需要把值赋给第一和第三个,不能写成(值1,,值3),必须把原来默认的值写上去.
```
<!-- less -->
.border(@x:solid,@c:red){
  border: 21px @arguments;
}
.div1{
  .border(solid);
}
<!-- css -->
.div1 {
  border: 21px solid #ff0000;
}
```

### 得到混合变量的返回值
```
<!-- less -->
.average(@x, @y) {
  @average: ((@x + @y) / 2);
  @he:(@x + @y);
}
div {
  .average(16px, 50px);
  padding: @average;
  margin: @he;
}
<!-- css -->
div {
  padding: 33px;
  margin: 66px;
}
```

