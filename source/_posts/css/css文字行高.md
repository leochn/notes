---
title: css文字行高
date: 2017-06-17 18:01:09
tags: css
---
## 行高概念
浏览器默认文字大小：16px
行高：是基线与基线之间的距离
行高=上间距+文字大小+下间距

![css行高](/assets/images/css/css行高001.png)
一行文字行高和父元素高度一致的时候，垂直居中显示
<!-- more -->

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>
<style>
    a.one{
        display: inline-block;
        width: 120px;
        height: 58px;
        background-color: red;
        text-align: center;
        text-decoration: none;
        color: white;
        line-height: 58px; /*文字行高和父元素a高度一致的时候，垂直居中显示*/
    }
</style>
<body>
    <a href="http://baidu.com" class='one'>五彩导航</a>
    <a href="#">五彩导航</a>
    <a href="#">五彩导航</a>
    <a href="#">五彩导航</a>
</body>
</html>
```

## 行高的单位

|行高单位   |文字大小       |值    |
| --------- | ------------- | ---- |
|20px       |20px           |20px  |
|2em        |20px           |40px  |
|150%       |20px           |30px  |
|2          |20px           |40px  |

总结:单位除了像素以为，行高都是与文字大小乘积。

## 行高与父子元素的关系

|行高单位   |父元素文字大小   |子元素文字大小   |行高 |
| --------- | --------------- | --------------  | --- |
|40px       |20px             |30px             |40px |
|2em        |20px             |30px             |40px |
|150%       |20px             |30px             |30px |
|2          |20px             |30px             |60px |

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style type="text/css">
    .box {
        font-size: 20px;
        line-height: 2; /*不带单位时：行高是和子元素文字大小相乘*/
    }
    p {
        font-size: 30px;
    }
    </style>
</head>
<body>
    <div class="box">
        <p>文本行高</p>
    </div>
</body>
</html>
```

总结:
不带单位时：行高是和子元素文字大小相乘;
em和%的行高：是和父元素文字大小相乘;
行高以像素为单位：就是定义的行高值;

◆推荐行高使用像素为单位。





