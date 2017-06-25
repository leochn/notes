---
title: css之内容移除
date: 2017-06-25 07:16:56
tags:
---
## css之内容移除
常用于logo 优化
    1. 利用text-index:-2000em;
    2. 利用padding 挤开盒子 并且overflow 切割
    
<!-- more -->

```html
<!-- 隐藏a标签中的文字 -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style type="text/css">
        .logo{
            width: 143px;
            height: 76px;
            background: url("logo.png");
        }
        a{
            display: inline-block;
            text-indent:-5000em;
        }
    </style>
</head>
<body>
    <div class="logo">
        <h1>    
         <a href="#">搜狐</a>
        </h1>
    </div>
</body>
</html>
```

```html
<!-- 显示div,隐藏div内的文字 -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style type="text/css">
     .box{
        width: 300px;
        height: 0;
        padding-top: 100px;
        overflow: hidden;
        background: red;
     }
    </style>
</head>
<body>
    <div class="box">隐藏文字</div>
</body>
</html>
```