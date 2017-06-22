---
title: css定位的盒子居中显示
date: 2017-06-20 16:03:20
tags: css
---
## 定位的盒子居中显示
父盒子里面嵌套了子盒子,需求:子盒子相对于父盒子底部居中显示.
<!-- more -->

★:margin:0 auto;  只能让标准流的盒子居中对齐。
★定位的盒子居中：先向右走父元素盒子的50%，在向左走子自己(子盒子)的一半(margin-left:负值。)

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style type="text/css">
        body{
            margin:0;
            padding:0;
        }
        .box{
            height: 500px;
            background: #aaa;
            position: relative;
        }
        .nav{
            width: 960px;
            height: 60px;
            background:#666;
            position: absolute;
            bottom:0;  /* 底部显示 */
            left:50%;  /* 向右走父元素盒子的50% */
            margin-left:-480px;  /* 向左走子自己的一半 */

        }
    </style>
</head>
<body>
    <div class="box">
        <div class="nav"></div>
    </div>
</body>
</html>
```

```html
<!-- demo -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style type="text/css">
        body,ul,li{
            margin:0;
            padding: 0;
        }
        ul,li{
            list-style: none;
        }
        .banner{
            width: 1259px;
            height: 472px;
            background: #aaa;
            margin: 0 auto;
            position: relative;
        }
        .search{
            width: 960px;
            height: 60px;
            background: #333;
            position: absolute;
            bottom:0;
            left:50%;
            margin-left:-480px;
        }
        .search ul li{
            float: left;
        }
        .search ul li a{
            display: inline-block;
            width: 160px;
            height: 60px;
            line-height: 60px;
            text-align: center;
            color:#fff;
        }
        .search ul li a:hover{
            background: #fff;
            color:#000;
        }
        .search ul li a.one:hover{
            background: #333;
            color:#fff;
        }
        .login{
            width: 100px;
            height: 100px;
            position: absolute;
            left:150px;
            bottom: 58px;
            background: red;
        }
    </style>
</head>
<body>
    <div class="banner">
        <div class="search">
            <ul>
                <li><a href="#" class="one">运单查询</a></li>
                <li><a href="#">运费查询</a></li>
                <li><a href="#">时效查询</a></li>
                <li><a href="#">服务网点查询</a></li>
                <li><a href="#">收送范围查询</a></li>
                <li><a href="#">客户专区</a></li>
            </ul>
        </div>
        <div class="login"></div>
    </div>
</body>
</html>
```





