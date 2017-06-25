---
title: css可见性
date: 2017-06-25 07:16:12
tags:
---
## css可见性
overflow:hidden;     溢出隐藏    
visibility:hidden;   隐藏元素    隐藏之后还占据原来的位置。
display:none;        隐藏元素    隐藏之后不占据原来的位置。
display:block;       元素可见
display:none  和 display:block  常配合js使用

<!-- more -->

## 小案例
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style type="text/css">
    .red{
        width: 300px;
        height: 300px;
        background: red;
        visibility:hidden;   
    }
    .green{
        width: 300px;
        height: 300px;
        background: green;
    }
    </style>
</head>
<body>
    <div class="red"></div>
    <div class="green"></div>
</body>
</html>
```

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style type="text/css">
        .box,.div1,.div2,.div3{
            width: 300px;
            height: 300px;
        }
        .box{
            overflow: hidden;
        }
        .div1{
            background: red;
        }
        .div2{
            background: green;
        }
        .div3{
            background: pink;
        }
    </style>
</head>
<body>
    <a href="#div1">div1</a>
    <a href="#div2">div2</a>
    <a href="#div3">div3</a>
    <div class="box">
        <div class="div1" id="div1"></div>
        <div class="div2" id="div2"></div>
        <div class="div3" id="div3"></div>
    </div>
</body>
</html>
```