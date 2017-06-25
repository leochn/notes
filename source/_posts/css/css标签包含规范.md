---
title: css标签包含规范
date: 2017-06-25 07:15:29
tags:
---
## css标签包含规范
div可以包含所有的标签。
p标签不能包含div h1等标签。
h1可以包含p，div等标签。
行内元素尽量包含行内元素，行内元素不要包含块元素。
<!-- more -->

##  规避脱标流
由于浮动，定位都脱离了标准流，会对网页布局造成一定的影响，在以后的网页布局中优先考虑：标准流，浮动，定位。

尽量使用标准流
标准流解决不了的使用浮动
浮动解决不了的使用定位
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style type="text/css">
        .father{
            width: 500px;
            height: 500px;
            background:red;
        }
        .son{
            width: 100px;
            height: 100px;
            background: green;
            /*设置盒子左外边距为auto，将盒子冲到右边*/
            margin-left:auto;
            
            /*margin-left:auto ;    让盒子左侧充满
            margin-right:auto ;   让盒子右侧充满
            margin:0 auto;         居中对齐的由来*/
        }
    </style>
</head>
<body>
    <div class="father">
        <div class="son"></div>
    </div>
</body>
</html>
```

##  图片和文字垂直居中对齐
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style type="text/css">
        img {
            /*图片和文字垂直居中对齐*/
            vertical-align: middle;
        };
    </style>
</head>
<body>
    <div class="box">
    <img src="1.png" alt="">天太热了！
    </div>
</body>
</html>
```

