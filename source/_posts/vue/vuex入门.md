---
title: vuex入门
date: 2017-05-29 06:54:29
tags: [vue,vuex]
---
## Vuex是什么
Vuex 是用来管理Vue的所有组件状态.

## 为什么使用Vuex
当你打算开发大型单页应用(SPA),会出现多个视图组件依赖同一个状态,来自不同视图的行为需要变更同一个状态.

遇到以上情况时候,你就应该考虑使用Vuex了,它能把组件的共享状态抽取出来,当做一个全局单例模式进行管理.这样不管你在何处改变状态,都会通知使用该状态的组件做出相应修改. <!-- more -->

## 简单的Vuex示例
### 小示例的效果
![vuex小示例](/assets/images/vue/vuex小示例-001.png)

### 小示例的目录结构
![vuex小示例](/assets/images/vue/vuex小示例-002.png)

### package.json的依赖
```
  "dependencies": {
    "vue": "^2.1.0"
  },
  "devDependencies": {
    "babel-core": "^6.0.0",
    "babel-loader": "^6.0.0",
    "babel-preset-es2015": "^6.0.0",
    "cross-env": "^3.0.0",
    "css-loader": "^0.25.0",
    "file-loader": "^0.9.0",
    "vue-loader": "^10.0.0",
    "vue-template-compiler": "^2.1.0",
    "vuex": "^2.0.0",
    "webpack": "^2.1.0-beta.25",
    "webpack-dev-server": "^2.1.0-beta.0"
  }
```

### main.js
```
import Vue from 'vue'
import App from './App.vue'

import store from './store'

new Vue({
    store,
    el: '#app',
    render: h => h(App)
})
```
### App.vue
import {mapGetters, mapActions} from 'vuex',
mapGetters: 获取数据
mapActions: 管理所有事件(行为)
```
<template>
  <div id="app">
    <h3>vuex小示例</h3>
    <input type="button" value="增加" @click="increment">
    <input type="button" value="减少" @click="decrement">
    <br>
    <br>
    <div>
      现在数字为: {{count}}
    </div>
  </div>
</template>

<script>
  import {mapGetters, mapActions} from 'vuex'
  // mapGetters: 获取数据
  // mapActions: 管理所有事件(行为)
  export default{
    computed:mapGetters([
      'count'  // 调用这个count方法,即触发store.js中getters的count方法.
    ]),
    methods:mapActions([
      'increment', // 调用这个increment方法,即触发store.js中actions的increment.
      'decrement'
    ])increment,
  }
</script>
```
### store.js
```
import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex);

var state = {
    count: 10
};

const mutations = {   //处理状态(数据)变化
    increment(state) { 
        state.count++;  // 这里改变state.count的状态.
    },
    decrement(state) {
        state.count--;
    }
};

const actions = {   //处理你要干什么，异步请求，判断，流程控制
    increment: ({ 
        commit
    }) => {
        commit('increment');  // 这里commit,即触发mutations中的increment方法.
    },
    decrement: ({
        commit
    }) => {
        commit('decrement');
    }
};

const getters = {
    count(state) {
        return state.count;
    }
};


//需要导出Store对象
export default new Vuex.Store({
    state,
    mutations,
    actions,
    getters
});
```

### 数据流向说明
在 xxx.vue 组件中使用 mapActions 暴露出的increment 方法,其实就是使用actions中的同名方法,actions中的方法会进行一个commit提交到mutations中,通过mutations来改变state中状态变量的值.

使用mapGetters 暴露出的 count ,其实就是使用 getters 中的同名方法来获取state中的状态值.