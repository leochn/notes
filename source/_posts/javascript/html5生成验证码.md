---
title: html5生成验证码
date: 2018-06-12 20:37:53
tags: [html,canvas]
---

## html5生成验证码
利用Html5的canvas标签生成画布,在画布上利用随机生成的数字画上验证码，背景为随机生成的颜色和杂乱的直线与点点。

进阶：利用表单插件属性绑定验证码数据(json)可以在发送时候或者异步通信进行后台数据获取与检查。
<!-- more -->

## 代码
```html
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>验证码</title>
    <style type="text/css">
    #canvas {
        cursor: pointer;
    }
    </style>
</head>

<body>
    <canvas id="canvas" width="150px" height="50px"></canvas>
    <script>
    //生成随机数
    function randomNum(min, max) {
        return Math.floor(Math.random() * (max - min) + min);
    }
    //生成随机颜色RGB分量
    function randomColor(min, max) {
        var _r = randomNum(min, max);
        var _g = randomNum(min, max);
        var _b = randomNum(min, max);
        return "rgb(" + _r + "," + _g + "," + _b + ")";
    }
    //先阻止画布默认点击发生的行为再执行drawPic()方法
    document.getElementById("canvas").onclick = function(e) {
        e.preventDefault();
        drawPic();
    };

    function drawPic() {
        //获取到元素canvas
        var $canvas = document.getElementById("canvas");
        var _str = "0123456789"; //设置随机数库
        var _picTxt = ""; //随机数
        var _num = 4; //4个随机数字
        var _width = $canvas.width;
        var _height = $canvas.height;
        var ctx = $canvas.getContext("2d"); //获取 context 对象
        ctx.textBaseline = "bottom"; //文字上下对齐方式--底部对齐
        ctx.fillStyle = randomColor(180, 240); //填充画布颜色
        ctx.fillRect(0, 0, _width, _height); //填充矩形--画画
        for (var i = 0; i < _num; i++) {
            var x = (_width - 10) / _num * i + 10;
            var y = randomNum(_height / 2, _height);
            var deg = randomNum(-45, 45);
            var txt = _str[randomNum(0, _str.length)];
            _picTxt += txt; //获取一个随机数
            ctx.fillStyle = randomColor(10, 100); //填充随机颜色
            ctx.font = randomNum(16, 40) + "px SimHei"; //设置随机数大小，字体为SimHei
            ctx.translate(x, y); //将当前xy坐标作为原始坐标
            ctx.rotate(deg * Math.PI / 180); //旋转随机角度
            ctx.fillText(txt, 0, 0); //绘制填色的文本
            ctx.rotate(-deg * Math.PI / 180);
            ctx.translate(-x, -y);
        }
        for (var i = 0; i < _num; i++) {
            //定义笔触颜色
            ctx.strokeStyle = randomColor(90, 180);
            ctx.beginPath();
            //随机划线--4条路径
            ctx.moveTo(randomNum(0, _width), randomNum(0, _height));
            ctx.lineTo(randomNum(0, _width), randomNum(0, _height));
            ctx.stroke();
        }
        for (var i = 0; i < _num * 10; i++) {
            ctx.fillStyle = randomColor(0, 255);
            ctx.beginPath();
            //随机画原，填充颜色
            ctx.arc(randomNum(0, _width), randomNum(0, _height), 1, 0, 2 * Math.PI);
            ctx.fill();
        }
        return _picTxt; //返回随机数字符串
    }
    drawPic();
    </script>
</body>

</html>
```
