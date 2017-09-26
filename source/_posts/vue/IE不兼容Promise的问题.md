---
title: IE不兼容Promise的问题
date: 2017-09-19 09:10:24
tags: vue
---
## IE报vuex requires a Promise polyfill in this browser的问题

![IE不兼容Promise](/assets/images/vue/IE不兼容Promise-001.png)

因为使用了 ES6 中用来传递异步消息的的Promise，而IE低版本的浏览器不支持。

![IE不兼容Promise](/assets/images/vue/IE不兼容Promise-002.png)

<!-- more -->
## 解决方法

### 第一步:安装 babel-polyfill
babel-polyfill可以模拟ES6使用的环境，可以使用ES6的所有新方法
```
npm install --save babel-polyfill
```

### 第二步:在build文件夹下
webpack.base.conf.js文件中使用
```
module.exports = {
  entry: {
    app: ["babel-polyfill", "./src/main.js"]
  }
};
```
替换
```
module.exports = {
  entry: {
    app:  './src/main.js'
  }
}
```