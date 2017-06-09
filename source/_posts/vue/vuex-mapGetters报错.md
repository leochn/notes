---
title: vuex mapGetters报错
date: 2017-06-07 12:22:17
tags: [vuex,webpack]
---
## vuex使用mapGetters,mapActions报错
这或许是个低级错误,但是由于作者使用vue不久,对vue了解的不是很深入.
产生错误的场景:用webpack-simple搭建项目,项目中使用到了vuex,在xxx.vue中使用 ...mapGetters, ...mapActions的时候报错,错误截图如下:
<!-- more -->

报错截图:
![mapGetters](/assets/images/vue/vuex-mapGetters-error.png)

![mapActions](/assets/images/vue/vuex-mapActions-error.png)

## 报错原因
在vuex的repo issues中有人提过这样的问题，后来是修改了eslint配置中对 Object Rest Operator 的支持解决了问题，然而我根本没有使用eslint.

## 解决办法
```
1 安装babel插件: babel-plugin-transform-object-rest-spread.
npm install babel-plugin-transform-object-rest-spread -D
npm install babel-preset-latest -D

2 .babel的配置文件修改为:
{
  "presets": [
    ["es2015", { "modules": false }]
  ],
  "plugins": ["transform-object-rest-spread"]
}

3 在main.js中导入
import store from "./store"
// ..........
new Vue({
  el: '#app',
  router,
  store,
  render: h => h(App)
})
```