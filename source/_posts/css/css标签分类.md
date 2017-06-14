---
title: css标签分类
date: 2017-06-14 09:13:23
tags: css
---
## 块元素
典型代表:div,h1...h6,p,ul,li
特点:独占一行;可以设置宽高;嵌套下,子块元素宽度(没有定义情况下)和父块元素宽度默认一致.
<!-- more -->

## 行内元素
典型代表:span,a,strong,em,del,ins
特点:在一行上显示;不能直接设置宽高;元素的宽和高是内容撑开的宽高.

## 行内块元素(内联元素)
典型代表:input,img
特点:在一行上显示;可以设置宽高.

## 块元素-行内元素
### 块元素转行内元素
```
/* 块元素转换为行内元素 */
div,p{
    dispaly:inline;
}
```

### 行内元素转块元素
```
span{
    dispaly:block;
}
```

### 块和行内元素转行内块元素
```
div,a,span,strong{
    dispaly:inline-block;
    width:200px;
    height:200px;
}