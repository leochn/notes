---
title: css三大特性
date: 2017-06-14 09:29:56
tags: css
---
## 层叠性
当多个样式作用于同一个（同一类）标签时，样式发生了冲突，总是执行后边的代码(后边代码层叠前边的代码)。和标签调用选择器的顺序没有关系。
<!-- more -->
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style type="text/css">
        .box2{
            font-size: 10px;
            color: blue;
        }
        .box{
            font-size: 30px;
            color: red;
        }

    </style>
</head>
<body>
    <!-- 显示为红色,30px -->
    <div class="box box2 ">css层叠性</div>
</body>
</html>
```

## 继承性
1.继承性发生的前提是包含（嵌套关系）
  文字颜色可以继承
  文字大小可以继承
  字体可以继续
  字体粗细可以继承
  文字风格可以继承
  行高可以继承
  总结：文字的所有属性都可以继承。
2.特殊情况：
  h系列不能继承文字大小。
  a标签不能继承文字颜色。

## 优先性
```
默认样式 < 标签选择器 < 类选择器 < id选择器 < 行内样式 <  !important 
    0         1          10          100       1000       1000以上
```

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style type="text/css">
    #con {
        color: pink;
        font-size: 100px;
    }
    .box {
        color: green;
        font-size: 30px;
    }   
    div {
        color: red !important;
        font-size: 20px !important;
    }
    </style>
</head>
<body>
    <!-- 显示: red;20px; -->
    <div class="box" id="con" style="font-size:12px; color:yellow;">css优先级</div>
</body>

</html>

```

优先级特点:继承的权重为0, 权重会叠加.
