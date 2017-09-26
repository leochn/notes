---
title: webpack打包后能看到vue的源码
date: 2017-09-26 17:00:12
tags: [vue,webpack]
---
## 用webpack打包vue工程后在浏览器中能够看到vue组件的源码

用webpack打包vue工程之后，在浏览器中能够看到vue组件的源码?
![webpack打包后浏览器看到vue组件源码](/assets/images/vue/webpack打包后浏览器看到vue组件源码.png)
<!-- more -->

## 解决办法
```
将 config/index.js 中 build 下的 productionSourceMap: true,
改为 productionSourceMap: false, 即可.
```
