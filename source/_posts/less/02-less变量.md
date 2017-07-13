---
title: 02-less变量
date: 2017-07-13 09:51:26
tags: [less,css]
---
## less变量
变量允许我们单独定义一系列通用的样式，然后在需要的时候去调用。所以在做全局样式调整的时候我们可能只需要修改几行代码就可以了。
<!-- more -->
### 普通变量
格式：@变量名:值;
用法：@变量名;
```
<!-- less -->
@green: #801f77;
@baise:white;

header,footer{
  background: @green;
  h1{
    color: @baise;
  }
}
<!-- css -->
header,
footer {
  background: #801f77;
}
header h1,
footer h1 {
  color: #ffffff;
}
```

### 作为选择器和属性名
格式:  @变量名:值;
用法:  @{变量名}
```
<!-- less -->

<!-- css -->

```

### 地址变量(作为URL的变量)
格式: @变量名："绝对路径";
用法: url("@{变量名}图片名称")
```
<!-- less -->
@green: #801f77;
//作为URL的变量
@imgurl:"https://www.baidu.com/img/";
header{
  background: @green url("@{imgurl}bdlogo.png");
  height: 500px;
}
<!-- css -->
header {
  background: #801f77 url("https://www.baidu.com/img/bdlogo.png");
  height: 500px;
}
```

### 定义多个相同名称的变量
```
<!-- less -->
//定义多个相同名称的变量时
@var: 0;  //变量赋值
.class {
  @var: 1;
    .brass {
      @var: 2;
      three: @var;  //这是的值是3
      @var: 3;
    }
  one: @var;  //这是的值是1
}
<!-- css -->
class {
  one: 1;
}
.class .brass {
  three: 3;
}
```


