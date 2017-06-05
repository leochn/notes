---
title: 关于Vue2中获取DOM元素
date: 2017-05-25 07:02:11
tags: vue
---
## 关于Vue2中获取DOM元素
在vue2.0中,已经对vue1.x中的v-ref、v-el 弃用 统一使用ref属性为元素或组件添加标记，然后通过this.$refs获取,下面是获取dom元素的实例.
<!-- more -->

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>关于Vue2中$refs获取DOM元素</title>  
    <script src="https://unpkg.com/vue/dist/vue.js"></script>
    <script>
        window.onload=function(){
            new Vue({
                el:'#box',
                data:{
                    msg:'welcome vue'
                },
                methods: {
                    alert1: function() {
                        console.log(this.$refs.div2);
                    }
                }
            });
        };
    </script>
</head>
<body>
    <div id="box">
        {{msg}}
        <br>
        <input type="button" value="Button" v-on:click="alert1()">
        <div ref='div2'>
            <h3>hello</h3>
        </div>
    </div>
</body>
</html>
```