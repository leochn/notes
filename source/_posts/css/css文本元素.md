---
title: css文本元素
date: 2017-06-14 08:29:04
tags: css
---
## 属性
font-size:16px;  文字大小
Font-weight:700 ;   值从100-900，文字粗细，不推荐使用font-weight:bold;
Font-family:微软雅黑; 文本的字体
Font-style:normal | italic;      normal 默认值  italic  斜体
line-height:行高
<!-- more -->

![css文本元素-属性](/assets/images/css/css文本元素-属性.png)

## 文本属性连写
```
font: font-style font-weight  font-size/line-height  font-family;
```

注意：
    font:后边写属性的值。一定按照书写顺序。
    文本属性连写文字大小和字体为必写项
```
Font:italic 700 16px/40px  微软雅黑;
```

## 文字的表达方式
### 直接写中文名称
```
div{
    font-family:微软雅黑;
    font-size:60px;
}
```
### 写字体的英文名称
```
div{
    font-family:microsoft yahei;
    font-size:60px;
}
```
### unicode 编码
![css文本元素-unicode编码](/assets/images/css/css文本元素-unicode编码.png)

### 在浏览器Console中直接查看编码
![css文本元素-查看编码](/assets/images/css/css文本元素-查看编码.png)
